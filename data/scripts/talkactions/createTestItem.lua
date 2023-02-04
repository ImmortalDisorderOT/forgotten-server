local talk = TalkAction("/testitem", "!testitem")



function talk.onSay(player, words, param)


	
	itemId = tonumber(param)
	if itemId then 
		result = player:addItem(itemId, 1)
		if result then
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			result:setRarity(MYTHICAL)
			result:setItemLevel(1000, true)
		else
			player:sendCancelMessage("something went wrong")
		end
	else
		player:sendCancelMessage("Must be a number")
	end

	return false

end

talk:separator(" ")
talk:register()
