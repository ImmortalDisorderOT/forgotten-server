local spell = Spell(SPELL_INSTANT)
spell:id(1)

spell:level(1)
spell:magicLevel(0)
spell:mana(20)

spell:name("Chain Lightning")
spell:words("Chain Lightning")
spell:group("attack")
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)

spell:needTarget(true)
spell:isAggressive(true)

spell:vocation("Tester")

local combat = Combat()

combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
--combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

function onGetFormulaValues(cid, level, maglevel)
    local base = 15
    local variation = 5

    local min = math.max((base - variation), ((3 * maglevel + 2 * level) * (base - variation) / 100))
    local max = math.max((base + variation), ((3 * maglevel + 2 * level) * (base + variation) / 100))

    return -min, -max
end
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local function doBlast(uid, pos, target, hits)
    local player = Player(uid)
    local position = Position(pos)
    local ctarget = Creature(target)
    if player and ctarget and position then
        position:sendDistanceEffect(ctarget:getPosition(), CONST_ANI_ENERGYBALL)
        combat:execute(player, numberToVariant(target))
        if hits > 1 then
            local newpos = ctarget:getPosition()
            local nextlist = Game.getSpectators(newpos, false, false, 3, 3, 3, 3)
            local newtarget = target
            if #nextlist > 0 then
                local possible = {}
                for i, v in pairs(nextlist) do
                    if v.uid ~= target and not v:isNpc() then
                        if v.uid == uid or (not player:hasSecureMode() or (not v:isPlayer() or v:getSkull() > 0)) then
                            if not v:isInGhostMode() then
                                possible[#possible + 1] = v.uid
                            end
                        end
                    end
                end
                if #possible > 0 then
                    newtarget = possible[math.random(1, #possible)]
                --else
                    --newtarget = nextlist[math.random(1, #nextlist)].uid
                end
            end
            addEvent(doBlast, 300, uid, newpos, newtarget, hits - 1)
        end
    end
    return true
end

function spell.onCastSpell(player, variant)
    local maglevel = player:getMagicLevel()
    local hits = math.max(3, 3 + math.floor(math.random(maglevel/15, maglevel/10)))
    doBlast(player.uid, player:getPosition(), variantToNumber(variant), hits)
    return true
end

spell:register()
