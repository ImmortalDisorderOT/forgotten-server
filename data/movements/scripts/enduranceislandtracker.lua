function onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() and item.actionid == g_enduranceIsland.config.playerInIslandTrackerActionId then
		g_enduranceIsland.playerIds[creature:getId()] = 1
		return true
	elseif creature:isPlayer() and item.actionid == g_enduranceIsland.config.playerOutIslandTrackerActionId then
		g_enduranceIsland.playerIds[creature:getId()] = nil
		return true
	end
	return true
end
