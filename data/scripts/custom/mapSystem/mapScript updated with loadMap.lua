--[[

Maps system written by Avaji

one suggestion - 
"I can’t remember the server name but one system had just a few different maps but based on difficulty 
it would load different monsters into it. I guess somewhat similar to Rangers dungeon system. But all the loot you would get at the end of the dungeon. It would fill a room at the end with the loot you made from the dungeon"

]]--

-- ACTIVEMAPS[pid] = {map, mapIndex, teleportPos, basePosition, event}

local config = {
    mapEndTimer = 5000, -- 5 seconds for testing only, timer after boss is killed
    mapSpawnTime = 60000 -- 10 seconds for testing only, timer upon opening the map
}
--Game.loadMapChunk("data/world/test.otbm", Position(1000, 1000, 0)) -- load the chunk
--addEvent(Game.loadMapChunk, 10000, "data/world/test.otbm", Position(1000, 1000, 0), true) -- remove it after 10 sec
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

local function spawnMobs(mapId, mapTopLeft)
    local mobs = {}

    for k in pairs(maps[mapId].mobs) do
        table.insert(mobs, k)
    end

    for __, spawn in ipairs(maps[mapId].spawns) do
        for i=1, spawn.maxMobs do
            local positionMob = getClosestFreePosition(Position(spawn.position.x + sendRandom(spawn.radius) + mapTopLeft.x, spawn.position.y + sendRandom(spawn.radius) + mapTopLeft.y, spawn.position.z))
            local monster = Game.createMonster(maps[mapId].mobs[math.random(#maps[mapId].mobs)], positionMob, false, true)
        end
    end
    -- spawn boss
    local bossSpawnPos = Position(maps[mapId].bossSpawn.x + mapTopLeft.x, maps[mapId].bossSpawn.y + mapTopLeft.y, maps[mapId].bossSpawn.z)
    local monster = Game.createMonster(maps[mapId].boss, bossSpawnPos, false, true)
    monster:registerEvent("BossMapKill")
end

local function clearMap(playerId)
	--#TODO fix this function, not clearing the map of monsters and player is not being removed
    local mapId = ACTIVEMAPS[playerId].map
    local mapIndex = ACTIVEMAPS[playerId].mapIndex
    local teleportPos = ACTIVEMAPS[playerId].teleportPos
    local mapTopLeft = Position(mapsArea.topLeft.x + mapsArea.instances[mapIndex].offsetX, mapsArea.topLeft.y + mapsArea.instances[mapIndex].offsetY, mapsArea.topLeft.z)
    local mapTeleport = Position(maps[mapId].teleportOutCreatePos.x + mapTopLeft.x, maps[mapId].teleportOutCreatePos.y + mapTopLeft.y, maps[mapId].teleportOutCreatePos.z)

    local centerPos = Position(mapTopLeft.x + mapsArea.instances[mapIndex].offsetX + (mapsArea.sizeX / 2), mapTopLeft.y + mapsArea.instances[mapIndex].offsetY + (mapsArea.sizeY / 2), 7)
    local mobsLeft = getSpectators(centerPos, mapsArea.sizeX / 2, mapsArea.sizeY / 2, maps[mapId].multiFloor)

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

    mapsArea.instances[mapIndex].active = false
    -- clear if there's an event happening ( re-open a map )
    if ACTIVEMAPS[playerId].event then
        stopEvent(ACTIVEMAPS[playerId].event)
    end
    ACTIVEMAPS[playerId] = nil
    local mapArea = Position(mapTopLeft.x, mapTopLeft.y, 0)
    Game.loadMapChunk("data/world/dungeonfiles/" .. maps[mapId].filename ..  ".otbm", mapArea, true)
end

-- Function that will remove the teleport after a given time
local function removeMap(playerId, position)
    if position then -- boss teleport position passed
        removeTeleport(position, playerId)
    end
    clearMap(playerId)
end

local function initMap(mapId, mapIndex, playerId, playerPos, mapTopLeft)

    local teleportPos = getClosestFreePosition(playerPos)
    local basePosition = getClosestFreePosition(teleportPos)

    if teleportPos.x == basePosition.x and teleportPos.y == basePosition.y then
        basePosition = getClosestFreePosition(basePosition)
    end

    spawnMobs(mapId, mapTopLeft)
    createTeleport(teleportPos, Position(maps[mapId].teleportToPos.x + mapTopLeft.x, maps[mapId].teleportToPos.y + mapTopLeft.y, maps[mapId].teleportToPos.z) , playerId)
    createTeleport(Position(maps[mapId].teleportOutCreatePos.x + mapTopLeft.x, maps[mapId].teleportOutCreatePos.y + mapTopLeft.y, maps[mapId].teleportOutCreatePos.z), basePosition, playerId)

    -- toggle active state
    ACTIVEMAPS[playerId] = {map = mapId, mapIndex = mapIndex, teleportPos = teleportPos, basePosition = basePosition, event = addEvent(removeMap, config.mapSpawnTime, playerId)}
    mapsArea.instances[mapIndex].active = true

    local mapMessage = "A " .. maps[mapId].name .. " map has opened, you have " .. formatTime(config.mapSpawnTime) .. " to clear it and kill the boss!"
    local player = Player(playerId)
    player:say(mapMessage, TALKTYPE_MONSTER_SAY, false, nil, playerPos)

    return
end

local mapAction = Action()

function mapAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    local party = player:getParty()
    if party then
        if party:getLeader():getName():lower() ~= player:getName():lower() then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Only the party leader can open a map!")
            return true
        end
    end

    local playerId = player:getId()

    -- check if it's even a map first
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

    for i, map in pairs(mapsArea.instances) do
        print("checking map index " .. i)
        if map.active == false then
            print("map not active, assigning to player")
            mapIndex = i
            map.active = true
            break
        end
    end

    if not mapIndex then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "There are no free maps of this type currently")
        return true
    end

    local mapTopLeft = Position(mapsArea.topLeft.x + mapsArea.instances[mapIndex].offsetX, mapsArea.topLeft.y + mapsArea.instances[mapIndex].offsetY, mapsArea.topLeft.z)
    local mapSpawnPos = Position(mapsArea.topLeft.x + mapsArea.instances[mapIndex].offsetX, mapsArea.topLeft.y + mapsArea.instances[mapIndex].offsetY, 0)

    Game.loadMapChunk("data/world/dungeonfiles/" .. maps[mapId].filename .. ".otbm", mapSpawnPos)

    addEvent(initMap, 1000, mapId, mapIndex, playerId, playerPos, mapTopLeft)

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
