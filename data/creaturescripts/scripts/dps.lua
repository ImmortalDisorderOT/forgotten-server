DPS_STORAGE = PlayerStorageKeys.DPSStorage
PLAYER_DPS = {}
PLAYER_EVENTS = {}

function ReadDPS(pid, cid)
    local player = Player(pid)
    local target = Monster(cid)
    if player and target then
        if PLAYER_DPS[pid] < 1 then
            PLAYER_DPS[pid] = PLAYER_DPS[pid] * -1
        end
        if PLAYER_DPS[pid] > player:getStorageValue(DPS_STORAGE) then
            player:setStorageValue(DPS_STORAGE, PLAYER_DPS[pid])
            target:say(string.format("New Record! DPS: %d", PLAYER_DPS[pid]), TALKTYPE_MONSTER_SAY, false, player, target:getPosition())
        else
            target:say(string.format("DPS: %d", PLAYER_DPS[pid]), TALKTYPE_MONSTER_SAY, false, player, target:getPosition())
        end
        PLAYER_DPS[pid] = 0
        PLAYER_EVENTS[pid] = nil
    end
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature then return primaryDamage, primaryType, secondaryDamage, secondaryType end
    if not attacker then return primaryDamage, primaryType, secondaryDamage, secondaryType end

    if creature:isMonster() and attacker:isPlayer() then
        if creature:getName() == "DPS Dummy" then
            local damage = primaryDamage + secondaryDamage
            local pid = attacker:getId()
            if not PLAYER_DPS[pid] then PLAYER_DPS[pid] = 0 end
            PLAYER_DPS[pid] = PLAYER_DPS[pid] + damage
            if not PLAYER_EVENTS[pid] then
                PLAYER_EVENTS[pid] = addEvent(ReadDPS, 1000, pid, creature:getId())
            end
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end