function onSay(player, words, param)
	if not player:getGroup():getAccess()  then
		return true
	end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Trying to spawn an endurance island")
    --@todo make into a little window that pops up to pick
    if not g_enduranceIsland:spawnEnduranceIsland() then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "failed to spawn")
    end
	return false

end