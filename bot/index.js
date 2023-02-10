const _ = require('lodash');
const fs = require('fs');
const Discord = require('discord.js');
const client = new Discord.Client();
const config = require('./config.json');

let outputChatChannelRef = null;
let outputChatChannelName = config.outputChatChannel;

const gameToDiscordFilePathAndName = config.gameToDiscordFilePathAndName;
const discordToGameFilePathAndName = config.discordToGameFilePathAndName;
const messageAuthorName = config.messageAuthorName;

let messagesToInboundQueue = [];
let running = false;

client.on('ready', () => {
	console.log(`[INIT] Logged in as ${client.user.tag}!`);
	client.channels.cache.forEach((channel, sn) => {
		if(channel.name == outputChatChannelName) {
			outputChatChannelRef = channel;
			running = true;
			console.log(`[INIT] #${outputChatChannelName} channel found and set`);
		}
	});

	if(!outputChatChannelRef) {
		throw new Error(`Could not find #${outputChatChannelName} channel`, client.channels);
	}
});

client.on('message', msg => {
	if (msg.channel.name == outputChatChannelName && msg.member.displayName != messageAuthorName) {
		const authorName = `${msg.member.displayName}`
		let msgBody = sanitizeInboundMessage(msg.content);
		let messageToInbound = `${authorName}: ${msgBody}`;
		writeMessageToInbound(messageToInbound);
	}
});

client.login(config.token);


function sanitizeOutboundMessage(msgs) {
	let lines = msgs.split('\n');

	lines = lines.filter((line) => {
		return line && line.length > 0 && line != "\n";
	})

	return lines;
}

function sanitizeInboundMessage(msg) {
	return msg.substr(0, 220);
}

function writeMessageToInbound(msg) {
	messagesToInboundQueue.push(msg);
}


let readLock = false;
function readAndPostOutboundMessages() {
	if(readLock || !running) {
		return;
	}
	readLock = true;
	fs.readFile(gameToDiscordFilePathAndName, 'ascii', (err, data) => {
		if(err) {
			console.error(err);
			readLock = false;
			throw err;
		}

		let msg = sanitizeOutboundMessage(data);
		if(msg.length > 0) {
			outputChatChannelRef.send(`${data}`);

			fs.truncate(gameToDiscordFilePathAndName, (truncErr, st) => {
				if(truncErr) {
					console.error(truncErr);
					readLock = false;
					throw truncErr;
				}

				readLock = false;
			});
		} else {
			readLock = false;
		}
	});

}

let writeLock = false;
function writeInboundMessages() {
	if(writeLock || !running) {
		return;
	}
	if(messagesToInboundQueue.length == 0) {
		return;
	}
	writeLock = true;

	let msg = messagesToInboundQueue.join('\n');
	msg += "\n";
	fs.writeFile(discordToGameFilePathAndName, msg, 'ascii', (err) => {
		if(err) {
			console.error(err);
			writeLock = false;
			throw err;
		}
		messagesToInboundQueue.length = 0;
		writeLock = false;
	});
}

setInterval(readAndPostOutboundMessages, 1500);
setInterval(writeInboundMessages, 1500);
