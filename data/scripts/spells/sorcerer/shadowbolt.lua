local spell = Spell(SPELL_INSTANT)

spell:name("Shadow Bolt")
spell:words("shadow bolts")
spell:group("attack")
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:id(3)
spell:level(60)
spell:mana(100)
spell:range(4)
spell:magicLevel(0)
spell:needTarget(true)
spell:isAggressive(true)
spell:isBlockingWalls(true)
spell:needLearn(false)
spell:vocation("Sorcerer")
spell:vocation("Master Sorcerer")
spell:vocation("Druid")
spell:vocation("Elder Druid")

local minMissiles = 2

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)

function onGetFormulaValues(player, level, magicLevel)
    local base = 30
    local variation = 10

	local min = (level / 5) + (magicLevel * 2.3) + 32
	local max = (level / 4) + (magicLevel * 4.4) + 48

    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")


local function doBolt(cid, var, tar, pos, check)
    local player = Player(cid)
    local target = Creature(tar)
    local position = Position(pos)

    if player and target and position then
        if check >= 5 then
            position:sendDistanceEffect(target:getPosition(), CONST_ANI_DEATH)
            combat:execute(player, var)
        else
            check = check + 1
            local a, b = math.random(-1,1), math.random(-1,1)
            local npos = {x = pos.x + a, y = pos.y +b, z = pos.z}
            position:sendDistanceEffect(Position(npos), CONST_ANI_DEATH)
            addEvent(doBolt, 100, cid, var, tar, npos, check)
        end
    end
    return true
end

function spell.onCastSpell(creature, variant, isHotkey)
    local mlv = creature:getMagicLevel()
    local pos = creature:getPosition()

    for i = 1, (minMissiles + math.floor(mlv/20)) do
        doBolt(creature.uid, variant, variantToNumber(variant), {x = pos.x, y = pos.y, z = pos.z}, 0)
    end
	return true
end

spell:register()

