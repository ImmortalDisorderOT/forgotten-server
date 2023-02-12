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
            --@todo CHECK FOR PZ
            if tile and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH) then
                return checkPosition 
            end
        end
    end
    return Position()
end

local function spawnEnduranceIslandWave()

    local currentIsland = enduranceIslandCurrRaid.currentIsland.type
    local currentRaid = enduranceIslandCurrRaid.currentIsland.index
    local mobs = enduranceIslandRaids[currentIsland][currentRaid].monsters
    local spawnRadius = enduranceIslandConfig.spawnRadius
    local maxMobs = enduranceIslandRaids[currentIsland][currentRaid].maxMobs

    for __, spawn in ipairs(enduranceIslandAreas[currentIsland].monsterSpawns) do
        for i=1, maxMobs do
            local positionMob = getClosestFreePosition(Position(spawn.x + sendRandom(spawnRadius), spawn.y + sendRandom(spawnRadius), spawn.z))
            local monster = Game.createMonster(mobs[math.random(#mobs)], positionMob, false, true)
                if not monster then
                    --print("failed to spawn ".. mobs[math.random(#mobs)] .. " at " .. positionMob.x .. ", " .. positionMob.y)
                end
        end
    end

    -- spawn boss
    if enduranceIslandCurrRaid.currentWave == enduranceIslandRaids[currentIsland][currentRaid].bossWave then
        local bossSpawnPos = enduranceIslandAreas[currentIsland].bossSpawnPos
        local monster = Game.createMonster(enduranceIslandRaids[currentIsland][currentRaid].boss, bossSpawnPos, false, true)
        monster:registerEvent("EnduranceBossKill")
        monster:setSkull(enduranceIslandRaids[currentIsland][currentRaid].skull)
        monster:setMaxHealth(monster:getMaxHealth() * enduranceIslandRaids[currentIsland][currentRaid].bossHealthMulti)
        monster:setHealth(monster:getMaxHealth())
        Game.broadcastMessage("The endurance island guardian has awoken!", MESSAGE_STATUS_WARNING)
    end
    if not (enduranceIslandCurrRaid.currentWave == enduranceIslandRaids[currentIsland][currentRaid].waves) then
        enduranceIslandCurrRaid.currentWave = enduranceIslandCurrRaid.currentWave + 1
        enduranceIslandCurrRaid.waveEvent = addEvent(spawnEnduranceIslandWave, enduranceIslandConfig.timeBetweenWaves)
    else
        Game.broadcastMessage("The endurance island seems to be growing quietier...", MESSAGE_STATUS_WARNING)
    end
end


local function clearEnduranceIsland()
    local centerPos = enduranceIslandAreas[enduranceIslandCurrRaid.currentIsland.type].centerPos
    local xRange = enduranceIslandAreas[enduranceIslandCurrRaid.currentIsland.type].xRange
    local yRange = enduranceIslandAreas[enduranceIslandCurrRaid.currentIsland.type].yRange

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

    removeTeleport(enduranceIslandConfig.teleportToIslandPos)

    enduranceIslandCurrRaid.activeRaid = false
    enduranceIslandCurrRaid.currentWave = 0
    enduranceIslandCurrRaid.currentIsland = {type = nil, index = 0}

    Game.broadcastMessage("The endurance island has fallen slient.", MESSAGE_STATUS_WARNING)
end

local function trySpawnEnduranceIsland(island)
    if Game.getPlayerCount() < enduranceIslandConfig.requiredNumOfPlayers then
        return false
    end

    if enduranceIslandCurrRaid.activeRaid == true then
        stopEvent(enduranceIslandCurrRaid.clearEvent)
        stopEvent(enduranceIslandCurrRaid.waveEvent)
        clearEnduranceIsland()
    end

    local totalLevel = 0
    local playerAmount = 0
    for _, player in ipairs(Game.getPlayers()) do
		playerAmount = playerAmount + 1
        totalLevel = totalLevel + player:getLevel()
	end

    -- local averageLevel = totalLevel / playerAmount -- average level to be considered later
    if island then
        enduranceIslandCurrRaid.currentIsland.type = island.type
        enduranceIslandCurrRaid.currentIsland.index = island.index
    else
        enduranceIslandCurrRaid.currentIsland.type = enduranceIslandTypes[math.random(1,4)]
        enduranceIslandCurrRaid.currentIsland.index = math.random(1, #enduranceIslandRaids[enduranceIslandCurrRaid.currentIsland.type])
    end

    local enduranceIslandName = enduranceIslandRaids[enduranceIslandCurrRaid.currentIsland.type][enduranceIslandCurrRaid.currentIsland.index].name

    if not enduranceIslandName then
        -- something went wrong, probably with someone trying the talk action
        print("endurance island failed to spawn")
        return false
    end
    Game.broadcastMessage("The endurance island has awoken! " .. enduranceIslandName .. " has invaded the island!", MESSAGE_STATUS_WARNING)

    createTeleport(enduranceIslandConfig.teleportToIslandPos, enduranceIslandAreas[enduranceIslandCurrRaid.currentIsland.type].teleportPos)

    enduranceIslandCurrRaid.activeRaid = true
    enduranceIslandCurrRaid.currentWave = 1
    spawnEnduranceIslandWave()

    enduranceIslandCurrRaid.clearEvent = addEvent(clearEnduranceIsland, enduranceIslandConfig.islandTotalTimer)

    return true
end


local enduranceIslandSpawner = GlobalEvent("enduranceIslandSpawner")

function enduranceIslandSpawner.onThink(...)
    if g_enduranceIsland:spawnEnduranceIsland() then
        print("endurance island spawned")
    end
	return true
end

enduranceIslandSpawner:interval(enduranceIslandConfig.timeBetweenIslandRaids) 
enduranceIslandSpawner:register()

local EnduranceBossKill = CreatureEvent("EnduranceBossKill")

function EnduranceBossKill.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local teleportPos = creature:getPosition()
    teleportPos = getClosestFreePosition(teleportPos) -- using closest free position so it doesnt spawn ON the boss (causing the corpse to teleport)
    createTeleport(teleportPos, enduranceIslandConfig.rewardRoomPosition)

    local killMessage = "You've killed the endurance island boss! A teleport has been created but it will disappear in " .. formatTime(enduranceIslandConfig.islandEndTimer) ..  "!"
    creature:say(killMessage, TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())

    addEvent(removeTeleport, enduranceIslandConfig.islandEndTimer, teleportPos)

    return true
end

EnduranceBossKill:register()


local talk = TalkAction("/spawnEI", "!spawnEI")

function talk.onSay(player, words, param)
	if not player:getGroup():getAccess()  then
		return true
	end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Trying to spawn an endurance island")
    --@todo make into a little window that pops up to pick
    if not trySpawnEnduranceIsland() then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "failed to spawn")
    end
	return false

end

talk:separator(" ")
talk:register()
