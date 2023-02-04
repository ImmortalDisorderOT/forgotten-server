-- fromPosition:sendDistanceEffect(toPosition, effect) (must be a Position() object)

local config = {
    combat = COMBAT_FIREDAMAGE,
    distanceEffect = 4,
    rounds = 2,
    delay = 250,
    firstEffect = 16,
    secondEffect = 7
}

local acombat, combat = createCombatObject(), createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, config.combat)

local combat2 = createCombatObject()
setCombatParam(combat2, COMBAT_PARAM_TYPE, config.combat)

local arr1 = {
{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
}

setCombatArea(combat2, createCombatArea(arr1))
setCombatArea(acombat, createCombatArea(arr1))

function onGetFormulaValues(player, skill, attack, factor)
    local min = 215
    local max = 230
    return -(min), -(max)
end

setCombatCallback(combat2, CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onGetFormulaValues(player, skill, attack, factor)
    local min = 0
    local max = 0
    return -min, -max
end

setCombatCallback(combat, CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local effect = {config.firstEffect,config.secondEffect}
function onTargetTile(cid, pos)
    return math.random(2) == 1 and pos:sendMagicEffect(effect[math.random(#effect)]) and  doSendDistanceShoot({ x = pos.x - 7, y = pos.y - 7, z = pos.z}, pos, 4) and doCombat(cid, combat, positionToVariant(pos))
end

setCombatCallback(acombat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function doTimeCombat(cid, combat, var)
     if isPlayer(cid) then
         doCombat(cid, combat, var)
         doCombat(cid, combat2, var)
     end
     return true
end

function onCastSpell(cid, var)
    local player = Player(cid)
     for x = 1, config.rounds do
         addEvent(doTimeCombat, (x-1) * config.delay, cid.uid, acombat, var)
     end
     return true
end
