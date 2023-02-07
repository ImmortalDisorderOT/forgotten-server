-- Credits to: Xikini for their onDeath_randomItemDrops.lua which helped learn the revscripts needed for this (Greatly helped learning the rev scripting with your public scripts)
-- Credits to: CodexNG for their Orb Siphoning script they uploaded that I based the early logic on to get started 

-- TODO: make meaningful orbs

local config = {
    orbTicks = 3, -- ticks, time is (timeBetweenOrbs * 1000) seconds, reduce to a lower number if orbs are being auto looted
    timeBetweenOrbs = 1000, -- time in milliseconds
    looter = 1, -- 1 = random player who damaged mod, 2 = most damage killer 3 = killer
    maxOrbs = 2, -- max orbs to spawn (rolls 1 .. max and then each orb has a chance to spawn defined by config.chance (who doesnt want to get lucky and see like 10 orbs?))
    autoLoot = true -- set to true if you want players to auto loot the orb, if false, they must stand on the orb 
}

-- list of orbs are now in a lib file, found in lib/custom

local function sendRandom(r)
    return math.random(-r, r)
end

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function getClosestFreePosition(position, creature)
    local maxRadius = 2
    local mustBeReachable = true

    local checkPosition = Position(position)

    checkPosition.x = checkPosition.x + sendRandom(1)
    checkPosition.y = checkPosition.y + sendRandom(1)

    for radius = 0, maxRadius do
        checkPosition.x = checkPosition.x - math.min(1, radius)
        checkPosition.y = checkPosition.y + math.min(1, radius)

        local total = math.max(1, radius * 8)
        for i = 1, total do
            if radius > 0 then
                local direction = math.floor((i - 1) / (radius * 2))
                checkPosition:getNextPosition(direction)
            end

            local tile = Tile(checkPosition)
            if tile and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) and
                (not mustBeReachable or creature:getPathTo(checkPosition)) and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH) then
                return checkPosition
            end
        end
    end
    return Position()
end

local function getRndOrbPosition(pos, killer)
    pos.x = pos.x + sendRandom(2)
    pos.y = pos.y + sendRandom(2)

    pos = getClosestFreePosition(pos, killer)
    return pos
end


local function giveReward(pid, orb)

    local player = Player(pid)
    if orb.type == "loot" then
        -- choose a tier inside items
        local rand = math.random(10000)
        for chance, index in pairs(orb.tiers) do
            if chance[1] <= rand and chance[2] >= rand then
                -- create loot list.
                local rewardItems = {}
                for i = 1, #index.itemList do
                    if math.random(10000) <= index.itemList[i][4] then
                        rewardItems[#rewardItems + 1] = i
                    end
                end
                -- give a random item, if there are any to give.
                if rewardItems[1] then
                    local rand = math.random(#rewardItems)
                    local itemId = index.itemList[rand][1]
                    local amount = math.random(index.itemList[rand][2], index.itemList[rand][3])
                    local name = ItemType(itemId):getName()
                    if amount > 1 then
                        name = name .. "s"
                    end
                    player:addItem(itemId, amount) -- give item
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "you siphoned " .. amount .. " " .. name .. " from the orb!") -- tell player
                end
                return true
            end
        end

    elseif orb.type == "gold" then
        local amountToGive = math.random(orb.min, orb.max) -- roll min and max amount
        player:setBankBalance(player:getBankBalance() + amountToGive) -- set in bank
        player:sendTextMessage(MESSAGE_INFO_DESCR, amountToGive .. " gold deposited into your bank account!") -- tell player
    elseif orb.type == "experience" then
        local amountToGive = math.random(orb.min, orb.max) -- rol min and max amount
        doPlayerAddExp(pid, amountToGive) -- give exp
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You gained "  ..  amountToGive .. " experience!") -- tell player
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "CONFIGURATION IS INCORRECT, REPORT TO AN ADMIN") -- something is wrong
    end

    return true
end

local function sendOrbEffect(orbPosition, pid, orb, tick)
    tick = tick or 1

    if config.autoLoot and tick >= config.orbTicks then -- if autolooting, give orb when orb expires
        giveReward(pid, orb)
        return true
    elseif tick >= config.orbTicks then -- not autolooting? just expire
        return true
    end

    local player = Player(pid)

    if not player then
        return true -- player somehow disconnected
    end

    if tick % 3 == 0 then -- only need it every 3 ticks ( if you have a tick time of 1000 )
        player:say(orb.text, TALKTYPE_MONSTER_SAY, false, player, orbPosition)
    end
    -- send magic effect
    orbPosition:sendMagicEffect(orb.effect, player)

    if player:getPosition() == orbPosition then -- get loot time! Give loot based on what the orb type is and tier
        giveReward(pid, orb)
        return true
    end

    -- resend event
    addEvent(sendOrbEffect, config.timeBetweenOrbs, orbPosition, pid, orb, (tick + 1))
end

local function rollOrbs(orbList, maxOrbs, skull)

    local extraChance = 0

    if getGlobalStorageValue(GlobalStorageKeys.orbBoostedTime) > os.time() then
		extraChance = extraChance + (getGlobalStorageValue(GlobalStorageKeys.orbBoostedRate) / 100)
	end

    if skull then
        extraChance = extraChance + uberMonsterTiers[skull].orbChanceMultiplier
    end

    local orbs = {}
    for i = 1, maxOrbs do
        local orb = orbList[math.random(#orbList)]
        local chance
        if extraChance > 0 then
            chance = orb.chance * extraChance
        else
            chance = orb.chance
        end
        local roll = math.random(100)
        if chance >= roll then
            table.insert(orbs, orb)
        end
	end

    return orbs
end

local creatureevent = CreatureEvent("orbloot")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    -- if the creature that died is a player, do nothing
    if creature:isPlayer() or creature:getMaster() then 
        return true 
    end
    -- check if mob has skull
    local skull

    if creature:getSkull() > SKULL_NONE then
        skull = creature:getSkull()
    else
        return true
    end

    local tier

    for index, orb in ipairs(orbs) do
        if creature:getMonsterLevel() >= orb.levelmin and creature:getMonsterLevel() <= orb.levelmax then
            tier = index
            break
        end
    end


    if not tier then
        return true  
    end

    -- pid getting ready for playerID
    local pid

    -- getting pid of person who will get the orb, based on config.looter
    if config.looter <= 1 then 
        local pids = {}
        for cid, _ in pairs(creature:getDamageMap()) do
            table.insert(pids, cid)
        end
        pid = pids[math.random(1, tablelength(pids))]
    elseif config.looter == 2 then
        pid = mostDamageKiller:getId()
    elseif config.looter >= 3 then
        pid = killer:getId()
    end -- pid is now set to the player who gets the orb

    if not pid then
        return true
    end


    -- get position of where the mob died
    local position = creature:getPosition()

    local orbsRolled

    if skull then
        orbsRolled = rollOrbs(orbs[tier].orblist, config.maxOrbs + uberMonsterTiers[skull].possibleExtraOrbs, skull)
    else
        orbsRolled = rollOrbs(orbs[tier].orblist, config.maxOrbs)
    end

    if orbsRolled and #orbsRolled > 0 then
        for i, orb in pairs(orbsRolled) do
            local orbPos = getRndOrbPosition(position, creature)
            local orbPlayer = Player(pid)

            orbPlayer:say(orb.text, TALKTYPE_MONSTER_SAY, false, orbPlayer, orbPos)
            orbPos:sendMagicEffect(orb.effect, orbPlayer)

            addEvent(sendOrbEffect, config.timeBetweenOrbs, orbPos, pid, orb)
        end
    end

    return true
end

creatureevent:register()
