local spell = Spell(SPELL_INSTANT)

spell:name("Eagle Eye")
spell:words("Eagle Eye")
spell:group("support")
spell:cooldown(40 * 1000)
spell:groupCooldown(2 * 1000)
spell:id(4)
spell:level(1)
spell:mana(20)
spell:magicLevel(0)
spell:needLearn(false)
spell:vocation("Sorcerer")

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local skill = Condition(CONDITION_ATTRIBUTES)
skill:setParameter(CONDITION_PARAM_TICKS, 20000)
skill:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, 150)
skill:setParameter(CONDITION_PARAM_DISABLE_DEFENSE, true)
skill:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
combat:addCondition(skill)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end


spell:register()
