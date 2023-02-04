-- webhook url https://discord.com/api/webhooks/1058284639078330388/M3MkZOnBY-EYgTr1xa5wBJolGvWCQwXqTU4btSTgdbbxa_BEv1-AjeQ_ZLLAINgvzUfc

local talk = TalkAction("/testwebhook", "!testwebhook")

function talk.onSay(player, words, param)


	return false

end

talk:separator(" ")
talk:register()
