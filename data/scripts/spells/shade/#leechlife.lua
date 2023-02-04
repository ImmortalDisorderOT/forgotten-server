local spell = Spell(SPELL_INSTANT)
spell:id(2)

spell:level(1)
spell:magicLevel(0)
spell:mana(20)

spell:name("Leech Life")
spell:words("Leech Life")
spell:group("attack")
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)

spell:needTarget(false)
spell:isAggressive(true)

spell:vocation("Sorcerer")

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
--combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat2:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, true)
combat2:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, magicLevel)
    local min = (level / 5) + (magicLevel * 4.5) + 20
    local max = (level / 5) + (magicLevel * 7.6) + 48
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onGetFormulaValues(player, level, magicLevel)
    local min = ((level / 5) + (magicLevel * 4.5) + 20) / 2
    local max = ((level / 5) + (magicLevel * 7.6) + 48) / 2
    return min, max
end

combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local function doLeech(player, target, variant, playerPos)

    local targetPos = target:getPosition()

    targetPos:sendDistanceEffect(playerPos, CONST_ANI_DEATH)

    combat:execute(player, variant)
    combat2:execute(player, variant)
end


function spell.onCastSpell(creature, variant)
    local playerPos = creature:getPosition()
    local spectators = Game.getSpectators(playerPos, false, false, 3, 3, 3, 3)
    local mobFound = false
    for i = 1, #spectators do
        local spectator = spectators[i]
        if not spectator:isPlayer() then
            mobFound = true
            doLeech(creature, spectator, variant, playerPos)
        end
    end
    if not mobFound then
        creature:sendCancelMessage("No monsters in range")
        playerPos:sendMagicEffect(CONST_ME_POFF)
        return false
    end
    return true
end

spell:register()

