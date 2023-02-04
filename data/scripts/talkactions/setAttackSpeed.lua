local talk = TalkAction("/attackspeed", "!attackspeed")

function talk.onSay(player, words, param)

	if not player:getGroup():getAccess()  then
		return true
	end
    player:setAttackSpeed(param)
end

talk:separator(" ")
talk:register()
