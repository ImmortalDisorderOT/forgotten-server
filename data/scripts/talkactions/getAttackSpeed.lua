local talk = TalkAction("/checkattackspeed", "!checkattackspeed")

function talk.onSay(player, words)
    player:sendTextMessage(MESSAGE_INFO_DESCR, player:getAttackSpeed())
end

talk:separator(" ")
talk:register()
