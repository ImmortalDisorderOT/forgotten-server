function onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    g_enduranceIsland.monsterIds[creature:getId()] = nil
    return true
end