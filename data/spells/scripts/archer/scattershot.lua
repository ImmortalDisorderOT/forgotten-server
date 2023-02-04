local areas = {
    [1] = {
        {0, 0, 0},
        {0, 3, 0},
        {0, 0, 0}
    },
    [2] = {
        {0, 1, 0},
        {1, 2, 1},
        {0, 1, 0}
    },
    [3] = {
        {0, 0, 1, 0, 0},
        {0, 1, 0, 1, 0},
        {1, 0, 2, 0, 1},
        {0, 1, 0, 1, 0},
        {0, 0, 1, 0, 0}
    },
    [4] = {
        {0, 1, 0, 1, 0},
        {1, 0, 0, 0, 1},
        {0, 0, 2, 0, 0},
        {1, 0, 0, 0, 1},
        {0, 1, 0, 1, 0}
    },
    [5] = {
        {0, 0, 1, 1, 1, 0, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 2, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 0, 1, 1, 1, 0, 0}
    },
    [6] = {
        {0, 0, 1, 1, 1, 1, 1, 0, 0},
        {0, 1, 1, 0, 0, 0, 1, 1, 0},
        {1, 1, 0, 0, 0, 0, 0, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 2, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 1, 0, 0, 0, 0, 0, 1, 1},
        {0, 1, 1, 0, 0, 0, 1, 1, 0},
        {0, 0, 1, 1, 1, 1, 1, 0, 0}
    },
    [7] = {
        {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
        {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
        {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}
    }
}
local combat = {}
local hit = Combat()
hit:setParameter(COMBAT_PARAM_EFFECT, 4)
hit:setParameter(COMBAT_PARAM_BLOCKSHIELD, 0)
hit:setParameter(COMBAT_PARAM_BLOCKARMOR, 0)
hit:setFormula(COMBAT_FORMULA_SKILL, 2.5, 0, 2.5, 0) -- 2.5, 0, 2.5, 0
hit:setArea(createCombatArea(areas[1]))

local function doShot(cid, target)
    local player = Player(cid)

    local target = Creature(target)
    if not target then return false end

    if player then
        local leftHand = pushThing(player:getSlotItem(CONST_SLOT_LEFT)).itemid
        local rightHand = pushThing(player:getSlotItem(CONST_SLOT_RIGHT)).itemid
        local ammoSlot = pushThing(player:getSlotItem(CONST_SLOT_AMMO)).itemid
        local dmgType, magicEffect = distance_damageTypes[ammoSlot]
        local removeAmmo, item

        if isInArray(Crossbows_ids, leftHand) or isInArray(Crossbows_ids, rightHand) then
            if (isInArray(Bolts_ids, ammoSlot)) then
                magicEffect = distance_animations[ammoSlot]
                removeAmmo = true
            end
        elseif (isInArray(Bows_ids, leftHand) or isInArray(Bows_ids, rightHand)) then
            if (isInArray(Arrows_ids, ammoSlot)) then
                magicEffect = distance_animations[ammoSlot]
                removeAmmo = true
            end
        elseif (isInArray(Throwables_ids, leftHand) or isInArray(Throwables_ids, rightHand)) then
            if (isInArray(Throwables_ids, leftHand)) then
                magicEffect = distance_animations[leftHand]
                dmgType = distance_damageTypes[leftHand]
                item = player:getSlotItem(CONST_SLOT_LEFT)
            else
                magicEffect = distance_animations[rightHand]
                dmgType = distance_damageTypes[rightHand]
                item = player:getSlotItem(CONST_SLOT_RIGHT)
            end
            removeAmmo = false
        else
            player:sendCancelMessage("You need a distance weapon to perform this spell.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return false
        end

        if removeAmmo then
            item = player:getSlotItem(CONST_SLOT_AMMO)
        end

        if item then
            local breakchance = item:getWeaponBreakChance()
            if breakchance and breakchance > 0 then
                if math.random(1,100) <= breakchance then
                    item:remove(1)
                end
            else
                item:remove(1)
            end
        else
            player:sendCancelMessage("You don't have the necessary ammunition to do more attacks.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return count == 1
        end

        hit:setParameter(COMBAT_PARAM_DISTANCEEFFECT, magicEffect)
        hit:setParameter(COMBAT_PARAM_TYPE, dmgType)
        local var = numberToVariant(target)
        hit:execute(player, var)
    end
end
for i = 1, #areas do
    combat[i] = Combat()
    combat[i]:setParameter(COMBAT_PARAM_EFFECT, 3)
    function onDetectCreature(cid, target)
        local pos = target:getPosition()
        if pos and not Npc(target.uid) then
            pos:sendMagicEffect(57, cid)
            addEvent(doShot, 500, cid.uid, target.uid)
        end
    end
    combat[i]:setArea(createCombatArea(areas[i]))
    combat[i]:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onDetectCreature")
end

function onCastSpell(cid, var)
    for j = 1, #combat do
        addEvent(function()
            if isPlayer(cid) then
                doCombat(cid, combat[j], var)
            end
        end, 90* (j - 1))
    end
    return true
end