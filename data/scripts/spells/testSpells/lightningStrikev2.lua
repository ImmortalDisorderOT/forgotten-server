-- fromPosition:sendDistanceEffect(toPosition, effect) (must be a Position() object)

local spell = Spell(SPELL_INSTANT)
spell:id(6)

spell:level(1)
spell:magicLevel(0)
spell:mana(20)

spell:name("Lightning Strike 2")
spell:words("Lightning Strike 2")
spell:group("attack")
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:isAggressive(true)
spell:needTarget(true)

spell:vocation("Sorcerer")


local config = {
    combat = COMBAT_ENERGYDAMAGE,
    distanceEffect = 60,
    effect = 244
}

local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, config.combat)

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 2.2) + 12
	local max = (level / 5) + (magicLevel * 3.4) + 21
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


local function doStrike(player, targetId, variant)
    local target = Creature(targetId)
    local targetPos = target:getPosition()
    targetPos:sendMagicEffect(config.effect)

    combat:execute(player, variant)
end

local function doChain(player, targetId, variant, startPos)
    local target = Creature(targetId)
    local targetPos = target:getPosition()
    targetPos:sendMagicEffect(config.effect)


    targetPos:sendDistanceEffect(specPos, config.distanceEffect)
    combat:execute(player, variant)
end


function spell.onCastSpell(creature, variant)
    local playerPos = creature:getPosition()
    local target = creature:getTarget()

    if not target then
        creature:sendCancelMessage("No creature targeted")
        playerPos:sendMagicEffect(CONST_ME_POFF)
        return false
    end
    
    local targetPos = target:getPosition()
    local startPos = Position(targetPos.x-7, targetPos.y-7, targetPos.z)
    startPos:sendDistanceEffect(Position(targetPos.x-1, targetPos.y-1, targetPos.z), config.distanceEffect)
    addEvent(doStrike, 300, creature:getId(), target:getId(), variant)

    local spectators = Game.getSpectators(targetPos, false, false, 2, 2, 2, 2)

    for i = 1, #spectators do
        if not spectators[i]:isPlayer() then
            local specPos = spectators[i]:getPosition()
            addEvent(doChain, 400, creature:getId(), spectators[i]:getId(), variant, specPos)
        end
    end

    return true
end

spell:register()
