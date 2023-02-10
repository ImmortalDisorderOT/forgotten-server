if not g_serverChat then
    g_serverChat = {
        messages = {}
    }
end

g_serverChat.config = {
    tibiaToDiscordFileName = "bot/tibia-to-discord.txt",
    discordToTibiaFileName = "bot/discord-to-tibia.txt"
}

g_serverChat.writeTibiaToDiscordChats = function(self)
    local tibiaToDiscordFile = assert(io.open(self.config.tibiaToDiscordFileName, "a+"))
    if not tibiaToDiscordFile then
        print("failed to open file tibiaToDiscordFile")
        return
    end
    for __, line in ipairs(self.messages) do
        tibiaToDiscordFile:write(line)
    end
    self.messages = {}
    tibiaToDiscordFile:close()
end

g_serverChat.readDiscordToTibiaChats = function(self)
    local discordToTibiaFile = assert(io.open(self.config.discordToTibiaFileName, "r"))
    if not discordToTibiaFile then
        print("failed to open file discordToTibiaFile")
        return
    end
    for line in io.lines(self.config.discordToTibiaFileName) do
        sendChannelMessage(3, TALKTYPE_CHANNEL_Y, line) -- 3 is the server chat channel
    end
    discordToTibiaFile:close()
    io.open(self.config.discordToTibiaFileName,"w"):close()
end

function onThink(...)
    if #g_serverChat.messages > 0 then
        g_serverChat:writeTibiaToDiscordChats()
    end
    g_serverChat:readDiscordToTibiaChats()
	return true
end