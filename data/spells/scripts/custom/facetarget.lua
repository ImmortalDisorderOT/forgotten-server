local function turnCreatureTowardPosition(creature, position)
    local creaturePosition = creature:getPosition()
    local x = creaturePosition.x - position.x
    local y = creaturePosition.y - position.y
    local angle = math.deg(math.atan2(y, x)) + 180
    
    if angle > 315 or angle <= 45 then
        creature:setDirection(DIRECTION_EAST)
    elseif angle <= 135 then
        creature:setDirection(DIRECTION_SOUTH)
    elseif angle <= 225 then
        creature:setDirection(DIRECTION_WEST)
    else
        creature:setDirection(DIRECTION_NORTH)
    end
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

function onGetFormulaValues(player, level, magicLevel)
    local min = (level / 5) + (magicLevel * 1.4) + 8
    local max = (level / 5) + (magicLevel * 2.2) + 14
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
    turnCreatureTowardPosition(creature, creature:getTarget():getPosition())
    return combat:execute(creature, variant)
end