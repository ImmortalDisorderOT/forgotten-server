function onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)

    local teleportPos = creature:getPosition()
    teleportPos = getRandomCloseFreePosition(teleportPos) -- using random close free position so it doesnt spawn ON the boss (causing the corpse to teleport)
    createTeleport(teleportPos, g_enduranceIsland.config.rewardRoomPosition)

    local killMessage = "You've killed the endurance island boss! A teleport has been created but it will disappear in " .. formatTime(g_enduranceIsland.config.islandEndTimer) ..  "!"
    creature:say(killMessage, TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())

    addEvent(removeTeleport, g_enduranceIsland.config.islandEndTimer, teleportPos)

    return true
end