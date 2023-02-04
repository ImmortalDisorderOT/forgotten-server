
local creatureevent = CreatureEvent("lootbageffect")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    -- if the creature that died is a player, do nothing
    if creature:isPlayer() then 
        return true 
    end
    local position = creature:getPosition()
	position.y = position.y + 1
	
	position:sendMagicEffect(243)
    return true
end

creatureevent:register()
