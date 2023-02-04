local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POISONAREA)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

function onGetFormulaValues(cid, level, maglevel)
    min = -((level * 2) + (maglevel * 2)) * 0.9
    max = -((level * 2) + (maglevel * 2)) * 1.5
    return min, max
end
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local condition = Condition(CONDITION_POISON)
condition:setParameter(condition, CONDITION_PARAM_DELAYED, 1)

local damageTable = {
    {4, -3},
    {9, -2},
    {20, -1}
}
for i = 1, #damageTable do
    local t = damageTable[i]
    condition:addDamage(t[1], 4000, t[2])
end
combat:addCondition(condition)

function onCastSpell(cid, var)
    local player = Player(cid)
    if player == nil then
        return false
    end

    local playerPos = player:getPosition()

    if #player:getSummons() >= 2 then
        player:sendCancelMessage("You cannot summon more creatures.")
        playerPos:sendMagicEffect(CONST_ME_POFF)
        return false
    end
    local dir = player:getDirection()
    local summonPos = player:getPosition()
    summonPos:getNextPosition(dir)

    local creatureId = doSummonCreature("Spider", summonPos)
    if creatureId == false then
        creatureId = doSummonCreature("Spider", playerPos)
        if creatureId == false then
            player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
            playerPos:sendMagicEffect(CONST_ME_POFF)
            return false
        end
    end

    local monster = Monster(creatureId)
    monster:setDirection(dir)
    monster:setMaster(player)
    player:addSummon(monster)
    monster:registerEvent("VolatileSpiderling")

    addEvent(function(cid, caster)
        local creature = Creature(cid)
        local player = Player(caster)
        if creature then
            if player then
                combat:execute(player, numberToVariant(cid))
            else
                combat:execute(creature, numberToVariant(cid))
            end
            creature:getPosition():sendMagicEffect(CONST_ME_HITBYPOISON)
            creature:remove()
        end
    end, math.random(3.5, 5.0) * 1000, creatureId, cid.uid)

    monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    playerPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
    return true
end