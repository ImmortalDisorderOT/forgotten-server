local talk = TalkAction("/eliteMonster", "!eliteMonster")



function talk.onSay(player, words, param)

	
	if not player:getGroup():getAccess()  then
		return true
	end
	

	local position = player:getPosition()
	local monster = Game.createMonster(param, position)
	if monster then
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
		monster:setSkull(SKULL_BLACK)
	else
		player:sendCancelMessage("There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return false

end

talk:separator(" ")
talk:register()
