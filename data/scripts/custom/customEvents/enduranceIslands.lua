print(">> Loaded Endurance Islands")

local function getClosestFreePosition(position)
    local maxRadius = 1

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

local function spawnEI_Wave()

    local currentIsland = EI_CurrRaid.currentIsland.type
    local currentRaid = EI_CurrRaid.currentIsland.index
    local mobs = EI_Raids[currentIsland][currentRaid].monsters
    local spawnRadius = EI_Config.spawnRadius
    local maxMobs = EI_Raids[currentIsland][currentRaid].maxMobs

    for __, spawn in ipairs(EI_Areas[currentIsland].monsterSpawns) do
        for i=1, maxMobs do
            local positionMob = getClosestFreePosition(Position(spawn.x + sendRandom(spawnRadius), spawn.y + sendRandom(spawnRadius), spawn.z))
            local monster = Game.createMonster(mobs[math.random(#mobs)], positionMob, false, true)
                if not monster then
                    --print("failed to spawn ".. mobs[math.random(#mobs)] .. " at " .. positionMob.x .. ", " .. positionMob.y)
                end
        end
    end

    -- spawn boss
    if EI_CurrRaid.currentWave == EI_Raids[currentIsland][currentRaid].bossWave then
        local bossSpawnPos = EI_Areas[currentIsland].bossSpawnPos
        local monster = Game.createMonster(EI_Raids[currentIsland][currentRaid].boss, bossSpawnPos, false, true)
        monster:registerEvent("EnduranceBossKill")
        monster:setSkull(SKULL_BLACK)
        monster:setMaxHealth(monster:getMaxHealth() * EI_Raids[currentIsland][currentRaid].bossHealthMulti)
        monster:setHealth(monster:getMaxHealth())
        Game.broadcastMessage("The endurance island guardian has awoken!", MESSAGE_STATUS_WARNING)
    end
    if not (EI_CurrRaid.currentWave == EI_Raids[currentIsland][currentRaid].waves) then
        EI_CurrRaid.currentWave = EI_CurrRaid.currentWave + 1
        EI_CurrRaid.waveEvent = addEvent(spawnEI_Wave, EI_Config.timeBetweenWaves)
    else
        Game.broadcastMessage("The endurance island seems to be growing quietier...", MESSAGE_STATUS_WARNING)
    end
end


local function clearEI()
    local centerPos = EI_Areas[EI_CurrRaid.currentIsland.type].centerPos
    local xRange = EI_Areas[EI_CurrRaid.currentIsland.type].xRange
    local yRange = EI_Areas[EI_CurrRaid.currentIsland.type].yRange

    local mobsLeft = getSpectators(centerPos, xRange, yRange)

    if mobsLeft ~= nil then
        for _, cid in pairs(mobsLeft) do
            local creature = Creature(cid)
            if not creature:isPlayer() then
                creature:remove()
            else
                creature:teleportTo(creature:getTown():getTemplePosition()) -- move the player to temple
            end
        end
    end

    removeTeleport(EI_Config.teleportToIslandPos)

    EI_CurrRaid.activeRaid = false
    EI_CurrRaid.currentWave = 0
    EI_CurrRaid.currentIsland = {type = nil, index = 0}

    Game.broadcastMessage("The endurance island has fallen slient.", MESSAGE_STATUS_WARNING)
end

local function trySpawnEI()
    if Game.getPlayerCount() < EI_Config.requiredNumOfPlayers then
        return true
    end

    if EI_CurrRaid.activeRaid == true then
        stopEvent(EI_CurrRaid.clearEvent)
        stopEvent(EI_CurrRaid.waveEvent)
        clearEI()
    end

    local totalLevel = 0
    local playerAmount = 0
    for _, player in ipairs(Game.getPlayers()) do
		playerAmount = playerAmount + 1
        totalLevel = totalLevel + player:getLevel()
	end

    -- local averageLevel = totalLevel / playerAmount -- average level to be considered later

    EI_CurrRaid.currentIsland.type = EI_Types[math.random(1,4)]
    EI_CurrRaid.currentIsland.index = math.random(1, #EI_Raids[EI_CurrRaid.currentIsland.type])

    Game.broadcastMessage("The endurance island has awoken!", MESSAGE_STATUS_WARNING)

    createTeleport(EI_Config.teleportToIslandPos, EI_Areas[EI_CurrRaid.currentIsland.type].teleportPos)

    EI_CurrRaid.activeRaid = true
    EI_CurrRaid.currentWave = 1
    spawnEI_Wave()

    EI_CurrRaid.clearEvent = addEvent(clearEI, EI_Config.islandTotalTimer)

end


local EI_Spawner = GlobalEvent("enduranceIslandSpawner")

function EI_Spawner.onThink(...)
    trySpawnEI()
	return true
end

EI_Spawner:interval(EI_Config.timeBetweenIslandRaids) -- will be executed every 1000ms
EI_Spawner:register()

local EnduranceBossKill = CreatureEvent("EnduranceBossKill")

function EnduranceBossKill.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local teleportPos = creature:getPosition()
    teleportPos = getClosestFreePosition(teleportPos) -- using closest free position so it doesnt spawn ON the boss (causing the corpse to teleport)
    createTeleport(teleportPos, EI_Config.rewardRoomPosition)

    local killMessage = "You've killed the endurance island boss! A teleport has been created but it will disappear in " .. formatTime(EI_Config.islandEndTimer) ..  "!"
    creature:say(killMessage, TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())

    addEvent(removeTeleport, EI_Config.islandEndTimer, teleportPos)

    return true
end

EnduranceBossKill:register()


local talk = TalkAction("/spawnEI", "!spawnEI")

function talk.onSay(player, words, param)
	if not player:getGroup():getAccess()  then
		return true
	end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Trying to spawn an endurance island")
    trySpawnEI()
	return false

end

talk:separator(" ")
talk:register()
