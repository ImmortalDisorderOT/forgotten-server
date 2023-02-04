-- TODO: fix the wave... can't seem to get it to do the drection the player is facing

local spell = Spell(SPELL_INSTANT)
spell:id(601)

spell:level(1)
spell:magicLevel(0)
spell:mana(20)

spell:name("Death Wave")
spell:words("death wave")
spell:group("attack")
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)

spell:needTarget(false)
spell:isAggressive(true)

spell:vocation("shade")

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setArea(createCombatArea(AREA_SQUAREWAVE5))

function onGetFormulaValues(player, level, magicLevel)
    local min = (level / 5) + (magicLevel * 4.5) + 20
    local max = (level / 5) + (magicLevel * 7.6) + 48
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function spell.onCastSpell(creature, variant)
    return combat:execute(creature, variant)
end

spell:register()

