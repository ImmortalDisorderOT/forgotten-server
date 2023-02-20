-- fromPosition:sendDistanceEffect(toPosition, effect) (must be a Position() object)

local spell = Spell(SPELL_INSTANT)
spell:id(5)

spell:level(1)
spell:magicLevel(0)
spell:mana(20)

spell:name("Lightning Strike")
spell:words("Lightning Strike")
spell:group("attack")
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:isAggressive(true)

spell:vocation("Sorcerer")
spell:vocation("Master Sorcerer")
spell:vocation("Druid")
spell:vocation("Elder Druid")


local config = {
    combat = COMBAT_ENERGYDAMAGE,
    distanceEffect = 60,
    effect = 244
}

local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, config.combat)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

function onGetFormulaValues(player, level, magicLevel)
	local max = (level / 5) + (magicLevel * 3.4) + 21
	local min = (level / 5) + (magicLevel * 2.2) + 12
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


local function doStrike(targetId)
    local target = Creature(targetId)
    local targetPos = target:getPosition()
    targetPos:sendMagicEffect(config.effect)
end


function spell.onCastSpell(creature, variant)
    local playerPos = creature:getPosition()
    local spectators = Game.getSpectators(playerPos, false, false, 4, 4, 4, 4)

    local mobFound = false

    for i = 1, #spectators do
        if not spectators[i]:isPlayer() then
            mobFound = true
            local specPos = spectators[i]:getPosition()
            local targetPos = Position(specPos.x-1, specPos.y-1, specPos.z)
            local startPos = Position(targetPos.x-7, targetPos.y-7, targetPos.z)

            startPos:sendDistanceEffect(targetPos, config.distanceEffect)

            addEvent(doStrike, 300, spectators[i]:getId())
        end
    end
    if not mobFound then
        creature:sendCancelMessage("No monsters in range")
        playerPos:sendMagicEffect(CONST_ME_POFF)
        return false
    else
        combat:execute(player, variant)
    end
    return true
end

spell:register()
