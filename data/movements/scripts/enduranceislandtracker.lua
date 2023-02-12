function onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() and item.actionid == g_enduranceIsland.config.playerInIslandTrackerActionId then
		g_enduranceIsland:addPlayer(creature)
		return true
	elseif creature:isPlayer() and item.actionid == g_enduranceIsland.config.playerOutIslandTrackerActionId then
		g_enduranceIsland:removePlayer(creature)
		return true
	end
	return true
end
