local minMissiles = 2

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)

function onGetFormulaValues(cid, level, maglevel)
    local base = 30
    local variation = 10

    local min = math.max((base - variation), ((3 * maglevel + 2 * level) * (base - variation) / 100))
    local max = math.max((base + variation), ((3 * maglevel + 2 * level) * (base + variation) / 100))

    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local function doBolt(cid, var, tar, pos, check)
    local player = Player(cid)
    local target = Creature(tar)
    local position = Position(pos)

    if player and target and position then
        if check >= 5 then
            position:sendDistanceEffect(target:getPosition(), 4)
            combat:execute(player, var)
        else
            check = check + 1
            local a, b = math.random(-1,1), math.random(-1,1)
            local npos = {x = pos.x + a, y = pos.y +b, z = pos.z}
            -- doSendMagicEffect(npos, CONST_ME_ENERGYAREA)
            position:sendDistanceEffect(Position(npos), 4)
            addEvent(doBolt, 100, cid, var, tar, npos, check)
        end
    end
    return true
end

function onCastSpell(player, var)
    local mlv = player:getMagicLevel()
    local pos = player:getPosition()

    for i = 1, (minMissiles + math.floor(mlv/20)) do
        doBolt(player.uid, var, variantToNumber(var), {x = pos.x, y = pos.y, z = pos.z}, 0)
    end
    return true
end
