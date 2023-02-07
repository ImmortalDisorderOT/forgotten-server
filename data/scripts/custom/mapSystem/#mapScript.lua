--[[

Maps system written by Avaji

]]--

-- ACTIVEMAPS[pid] = {map, mapIndex, teleportPos, basePosition, event}

local config = {
    mapEndTimer = 5000, -- 5 seconds for testing only, timer after boss is killed
    mapSpawnTime = 60000 -- 10 seconds for testing only, timer upon opening the map
}

--[[
    Function needed for the code to work
]] --


local function getActiveMapUser(monsterDamageMap)
    for i, _ in pairs(monsterDamageMap) do
        if ACTIVEMAPS[i] then
            return i
        end
    end
    return nil
end

local function getClosestFreePosition(position)
    local maxRadius = 2

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
            if tile and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH) then
                return checkPosition 
            end
        end
    end
    return Position()
end

--[[
    Map creation codes
]]--

local function spawnMobs(mapId, mapIndex)
    local mobs = {}

    for k in pairs(maps[mapId][mapIndex].mobs) do
        table.insert(mobs, k)
    end

    for __, spawn in ipairs(maps[mapId][mapIndex].spawns) do
        for i=1, spawn.maxMobs do
            local position = getClosestFreePosition(Position(spawn.position.x + sendRandom(spawn.radius), spawn.position.y + sendRandom(spawn.radius), spawn.position.z))
            local monster = Game.createMonster(maps[mapId][mapIndex].mobs[math.random(#mobs)], position, false, true)
        end
    end
    -- spawn boss
    local monster = Game.createMonster(maps[mapId][mapIndex].boss, maps[mapId][mapIndex].bossSpawn, false, true)
    monster:registerEvent("BossMapKill")
end

local function clearMap(playerId)

    local mapId = ACTIVEMAPS[playerId].map
    local mapIndex = ACTIVEMAPS[playerId].mapIndex
    local teleportPos = ACTIVEMAPS[playerId].teleportPos
    local mapTeleport = maps[mapId][mapIndex].teleportOutCreatePos

    local mobsLeft = getSpectators(maps[mapId][mapIndex].centerPos, maps[mapId][mapIndex].mapRangeX, maps[mapId][mapIndex].mapRangeY, maps[mapId][mapIndex].multiFloor) 

    if mobsLeft ~= nil then
        for _, cid in pairs(mobsLeft) do
            local creature = Creature(cid)
            if not creature:isPlayer() then
                doRemoveCreature(cid)
            else
                creature:teleportTo(creature:getTown():getTemplePosition()) -- move the player to temple
            end
        end
    end

    removeTeleport(teleportPos, playerId)
    removeTeleport(mapTeleport, playerId)

    maps[mapId][mapIndex].active = false
    -- clear if there's an event happening ( re-open a map )
    if ACTIVEMAPS[playerId].event then
        stopEvent(ACTIVEMAPS[playerId].event)
    end
    ACTIVEMAPS[playerId] = nil
end

-- Function that will remove the teleport after a given time
local function removeMap(playerId, position)
    if position then -- boss teleport position passed
        removeTeleport(position, playerId)
    end
    clearMap(playerId)
end

local function initMap(mapId, mapIndex, playerId, playerPos)

    local teleportPos = getClosestFreePosition(playerPos)
    local basePosition = getClosestFreePosition(teleportPos)

    if teleportPos.x == basePosition.x and teleportPos.y == basePosition.y then
        basePosition = getClosestFreePosition(basePosition)
    end

    spawnMobs(mapId, mapIndex)

    createTeleport(teleportPos, maps[mapId][mapIndex].teleportToPos, playerId)
    createTeleport(maps[mapId][mapIndex].teleportOutCreatePos, basePosition, playerId)

    -- toggle active state
    ACTIVEMAPS[playerId] = {map = mapId, mapIndex = mapIndex, teleportPos = teleportPos, basePosition = basePosition, event = addEvent(removeMap, config.mapSpawnTime, playerId)}
    maps[mapId][mapIndex].active = true

    local mapMessage = "A " .. maps[mapId][mapIndex].name .. " map has opened, you have " .. formatTime(config.mapSpawnTime) .. " to clear it and kill the boss!"
    local player = Player(playerId)
    player:say(mapMessage, TALKTYPE_MONSTER_SAY, false, nil, playerPos)

    return
end

local mapAction = Action()

function mapAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    local party = player:getParty()
    if party then
        local partyLeader = party:getLeader()
        if partyLeader:getName():lower() ~= player:getName():lower() then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Only the party leader can open a map!")
            return true
        end
    end

    -- check if it's even a map first
    local playerId = player:getId()
    local mapId = item:getId()
    if not mapIds[mapId] then
        return true
    end

    -- if player is PZ'd, do nothing
    if isPlayerPzLocked(playerId) then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cannot open a map while PZ locked!")
        return true
    end

    -- if player is in the ENTIRE SECTION  OF THE MAP WHERE THERE IS MAPS, DO NOTHING ( todo )
    if player:getPosition():isInRange(mapsArea.topLeft, mapsArea.bottomRight) then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cannot open a map while in a map!")
        return true
    end

    -- if playerID is in ACTIVEMAPS, delete old stuff
    if ACTIVEMAPS[playerId] ~= nil then
        clearMap(playerId)
    end

    local playerPos = player:getPosition()
    local mapIndex 

    for i, map in pairs(maps[mapId]) do
        if map.active == false then
            mapIndex = i
            map.active = true
            break
        end
    end

    if not mapIndex then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "There are no free maps of this type currently")
        return true
    end

    initMap(mapId, mapIndex, playerId, playerPos)

    -- todo: remove item on use ( when finished all testing )
    -- item:remove()

    return true
end

for i, val in pairs(mapIds) do
    mapAction:id(i)
end

mapAction:register()


local BossMapKillEvent = CreatureEvent("BossMapKill")

function BossMapKillEvent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local teleportPos = creature:getPosition()

    teleportPos = getClosestFreePosition(teleportPos) -- using closest free position so it doesnt spawn ON the boss (causing the corpse to teleport)

    local playerId = getActiveMapUser(creature:getDamageMap())

    if playerId then
        createTeleport(teleportPos, ACTIVEMAPS[playerId].basePosition, playerId)
    else
        createTeleport(teleportPos, killer:getTown():getTemplePosition(), playerId)
    end

    -- create teleport on the mob's position, to the ACTIVEMAPS area thing
    local killMessage = "You've killed the map boss! A teleport has been created but it will disappear in " .. formatTime(config.mapEndTimer) ..  "!"
    creature:say(killMessage, TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())

    -- Remove the teleport created and clear map after configured time
    stopEvent(ACTIVEMAPS[playerId].event) -- stopping the first clear map event
    ACTIVEMAPS[playerId].event = addEvent(removeMap, config.mapEndTimer, playerId, teleportPos) -- adding shorter time for clearing map

    return true
end

BossMapKillEvent:register()
