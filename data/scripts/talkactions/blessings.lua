local talk = TalkAction("/bless", "!bless")



function talk.onSay(player, words, param)
	local cost = 50000

	if not player:removeTotalMoney(cost) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"You don't have enough money for blessing.")
	else
		for i = 1, 5 do
			player:addBlessing(i)
		end
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"You have been blessed")
	end
	return false

end

talk:separator(" ")
talk:register()
