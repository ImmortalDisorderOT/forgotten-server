if not g_enduranceIsland then
    -- construct a fresh g_enduranceIsland because its not found in memory
    g_enduranceIsland = {
      currentRaid = {
        activeRaid = false,
        currentWave = 0,
        currentIsland = {type = nil, index = 0},
        clearEvent = nil,
        waveEvent = nil,
      },
      monsterIds = {},
      playerIds = {}
    }
end

g_enduranceIsland.config = {
    timeBetweenWaves = 1 * (1000 *  60), -- time between wave spawns
    islandEndTimer = 5 * (1000 *  60), -- time for portal to reward room
    islandTotalTimer = 30 * (1000 *  60), -- monsters will be on the map for 30 minutes (reduce lag)
    timeBetweenIslandRaids = 90 * (1000 * 60), -- 1 hour 30 mins between island raids
    rewardRoomPosition = Position(1402, 848, 7), -- position of reward room
    teleportToIslandPos =  Position(1166, 1116, 7), -- this is the position for creating a teleport to get to the island
    requiredNumOfPlayers = 2, -- less then 2 players, no island
    spawnRadius = 3, -- radius from a position in enduranceIslandAreas
    playerInIslandTrackerActionId = 15000,
    playerOutIslandTrackerActionId = 15001,
    teleportId = 1387,
}

-- change raid monster/bosses here
g_enduranceIsland.enduranceIslandRaids = {
    ["sandisland"] = {
        [1] = {
            name = "Undeads",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 10,
            monsters = {"ghoul", "skeleton", "skeleton warrior"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "demon skeleton",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 10,
        },
        [2] = {
            name = "Strong Undeads",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"demon skeleton", "vampire", "mummy"},
            maxMobs = 5, -- max mobs per spawn orb
            boss = "vampire lord",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 10,
        },
        [3] = {
            name = "Minotaurs",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 10,
            monsters = {"minotaur", "minotaur archer", "minotaur mage", "minotaur guard"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "general murius",
            skull = SKULL_BLACK,
            bossWave = 8,
            bossHealthMulti = 15,
        }
    },
    ["fireisland"] = {
        [1] = {
            name = "Dragons",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 10,
            monsters = {"dragon hatchling", "dragon lord hatchling", "dragon", "dragon lord"},
            maxMobs = 5, -- max mobs per spawn orb
            boss = "demodras",
            skull = SKULL_BLACK,
            bossWave = 8,
            bossHealthMulti = 10,
        },
        [2] = {
            name = "Firey Elementals",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"fire elemental", "massive fire elemental"},
            maxMobs = 5, -- max mobs per spawn orb
            boss = "fury",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 10,
        },
        [3] = {
            name = "Demons",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"demon", "massive fire elemental"},
            maxMobs = 5, -- max mobs per spawn orb
            boss = "orshabaal",
            skull = SKULL_WHITE,
            bossWave = 10,
            bossHealthMulti = 15,
        }
    },
    ["iceisland"] = {
        [1] = {
            name = "Barbarians",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 10,
            monsters = {"barbarian bloodwalker", "barbarian brutetamer", "barbarian headsplitter"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "barbarian skullhunter",
            skull = SKULL_BLACK,
            bossWave = 8,
            bossHealthMulti = 10,
        },
        [2] = {
            name = "Frost Giants",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"frost giant", "frost giantess", "frost dragon hatchling"},
            maxMobs = 5, -- max mobs per spawn orb
            boss = "frost dragon",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 10,
        }
    },
    ["grassisland"] = {
        [1] = {
            name = "Elves",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"elf", "elf scout", "elf arcanist"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "elf overseer",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 10,
        },
        [2] = {
            name = "Orcs",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"orc", "orc warrior", "orc spearman", "orc shaman"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "orc leader",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 10,
        },
        [3] = {
            name = "Wizards",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"warlock", "necromancer", "infernalist"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "ferumbras",
            skull = SKULL_WHITE,
            bossWave = 10,
            bossHealthMulti = 15,
        }
    }
}

-- only edit if island changes
g_enduranceIsland.enduranceIslandAreas = {
    ["sandisland"] = {
        topLeft = Position(1219, 916, 7),
        bottomRight = Position(1278, 1043, 7),
        centerPos = Position(1248, 971, 7),
        xRange = 40,
        yRange = 75,
        bossSpawnPos = Position(1245, 1023, 7),
        teleportPos = Position(1236, 925, 7),
        monsterSpawns = {
            Position(1244, 924, 7),
            Position(1235, 930, 7),
            Position(1245, 931, 7),
            Position(1254, 925, 7),
            Position(1261, 935, 7),
            Position(1252, 939, 7),
            Position(1236, 939, 7),
            Position(1248, 946, 7),
            Position(1260, 947, 7),
            Position(1267, 948, 7),
            Position(1228, 942, 7),
            Position(1226, 950, 7),
            Position(1234, 956, 7),
            Position(1225, 958, 7),
            Position(1244, 958, 7),
            Position(1251, 952, 7),
            Position(1260, 956, 7),
            Position(1263, 963, 7),
            Position(1247, 964, 7),
            Position(1235, 964, 7),
            Position(1226, 966, 7),
            Position(1229, 973, 7),
            Position(1240, 972, 7),
            Position(1251, 972, 7),
            Position(1259, 972, 7),
            Position(1268, 971, 7),
            Position(1239, 977, 7),
            Position(1230, 979, 7),
            Position(1258, 982, 7),
            Position(1268, 981, 7),
            Position(1259, 988, 7),
            Position(1240, 985, 7),
            Position(1231, 986, 7),
            Position(1247, 989, 7),
            Position(1269, 989, 7),
            Position(1252, 993, 7),
            Position(1235, 998, 7),
            Position(1245, 998, 7),
            Position(1259, 1000, 7),
            Position(1268, 996, 7),
            Position(1252, 1004, 7),
            Position(1239, 1005, 7),
            Position(1245, 1012, 7),
            Position(1241, 1023, 7),
            Position(1249, 1023, 7),
            Position(1245, 1029, 7),
           
        },
    },
    ["fireisland"] = {
        topLeft = Position(1335, 916, 7),
        bottomRight = Position(1378, 1028, 7),
        centerPos = Position(1357, 973, 7),
        xRange = 40,
        yRange = 75,
        bossSpawnPos = Position(1358, 931, 7),
        teleportPos = Position(1340, 1023, 7),
        monsterSpawns = {
            Position(1346, 1021, 7),
            Position(1352, 1023, 7),
            Position(1358, 1020, 7),
            Position(1366, 1021, 7),
            Position(1342, 1013, 7),
            Position(1342, 1006, 7),
            Position(1360, 1014, 7),
            Position(1371, 1017, 7),
            Position(1364, 1009, 7),
            Position(1355, 1005, 7),
            Position(1350, 1007, 7),
            Position(1360, 1001, 7),
            Position(1351, 1000, 7),
            Position(1344, 996, 7),
            Position(1368, 996, 7),
            Position(1367, 990, 7),
            Position(1361, 987, 7),
            Position(1355, 992, 7),
            Position(1349, 987, 7),
            Position(1342, 987, 7),
            Position(1339, 979, 7),
            Position(1357, 981, 7),
            Position(1367, 979, 7),
            Position(1356, 973, 7),
            Position(1345, 973, 7),
            Position(1366, 967, 7),
            Position(1358, 959, 7),
            Position(1354, 967, 7),
            Position(1348, 964, 7),
            Position(1343, 960, 7),
            Position(1341, 955, 7),
            Position(1371, 957, 7),
            Position(1368, 952, 7),
            Position(1359, 953, 7),
            Position(1351, 952, 7),
            Position(1341, 943, 7),
            Position(1357, 947, 7),
            Position(1357, 940, 7),
            Position(1350, 931, 7),
            Position(1356, 925, 7),
            Position(1356, 925, 7),
            Position(1369, 933, 7),
        },
    },
    ["iceisland"] = {
        topLeft = Position(1444, 897, 7),
        bottomRight = Position(1502, 1041, 7),
        centerPos = Position(1473, 970, 7),
        xRange = 40,
        yRange = 75,
        bossSpawnPos = Position(1472, 924, 7),
        teleportPos = Position(1449, 1023, 7),
        monsterSpawns = {
            Position(1452, 1020, 7),
            Position(1458, 1028, 7),
            Position(1472, 1024, 7),
            Position(1480, 1029, 7),
            Position(1483, 1016, 7),
            Position(1479, 1011, 7),
            Position(1455, 1005, 7),
            Position(1473, 1001, 7),
            Position(1487, 1000, 7),
            Position(1461, 997, 7),
            Position(1460, 986, 7),
            Position(1476, 988, 7),
            Position(1482, 983, 7),
            Position(1490, 986, 7),
            Position(1492, 976, 7),
            Position(1485, 970, 7),
            Position(1480, 974, 7),
            Position(1465, 976, 7),
            Position(1458, 971, 7),
            Position(1456, 979, 7),
            Position(1470, 967, 7),
            Position(1465, 958, 7),
            Position(1458, 956, 7),
            Position(1456, 949, 7),
            Position(1464, 946, 7),
            Position(1474, 950, 7),
            Position(1483, 956, 7),
            Position(1494, 955, 7),
            Position(1487, 948, 7),
            Position(1473, 942, 7),
            Position(1473, 932, 7),
            Position(1466, 928, 7),
            Position(1466, 918, 7),
            Position(1479, 915, 7),
            Position(1479, 926, 7),
        },
    },
    ["grassisland"] = {
        topLeft = Position(1566, 896, 7),
        bottomRight = Position(1628, 1056, 7),
        centerPos = Position(1600, 968, 7),
        xRange = 40,
        yRange = 75,
        bossSpawnPos = Position(1594, 1036, 7),
        teleportPos = Position(1576, 903, 7),
        monsterSpawns = {
            Position(1582, 905, 7),
            Position(1577, 913, 7),
            Position(1590, 911, 7),
            Position(1603, 908, 7),
            Position(1613, 907, 7),
            Position(1606, 918, 7),
            Position(1619, 922, 7),
            Position(1615, 931, 7),
            Position(1605, 929, 7),
            Position(1594, 930, 7),
            Position(1602, 935, 7),
            Position(1577, 925, 7),
            Position(1584, 931, 7),
            Position(1611, 938, 7),
            Position(1578, 941, 7),
            Position(1585, 945, 7),
            Position(1592, 949, 7),
            Position(1610, 953, 7),
            Position(1622, 950, 7),
            Position(1614, 949, 7),
            Position(1618, 955, 7),
            Position(1598, 956, 7),
            Position(1605, 961, 7),
            Position(1611, 964, 7),
            Position(1619, 968, 7),
            Position(1579, 958, 7),
            Position(1580, 965, 7),
            Position(1577, 970, 7),
            Position(1600, 972, 7),
            Position(1592, 977, 7),
            Position(1604, 979, 7),
            Position(1619, 981, 7),
            Position(1622, 992, 7),
            Position(1607, 990, 7),
            Position(1585, 989, 7),
            Position(1578, 984, 7),
            Position(1590, 993, 7),
            Position(1621, 1000, 7),
            Position(1618, 1006, 7),
            Position(1607, 1001, 7),
            Position(1606, 1007, 7),
            Position(1592, 1008, 7),
            Position(1579, 1005, 7),
            Position(1595, 1012, 7),
            Position(1594, 1017, 7),
            Position(1590, 1026, 7),
            Position(1603, 1030, 7),
            Position(1586, 1037, 7),
            Position(1602, 1040, 7),
            Position(1594, 1043, 7),
        },
    },
}

g_enduranceIsland.enduranceIslandTypes = {"sandisland", "fireisland", "iceisland", "grassisland"}

g_enduranceIsland.spawnEnduranceIslandWave = function(self)
    local currentIsland = self.currentRaid.currentIsland.type
    local currentRaid =self.currentRaid.currentIsland.index
    local mobs = self.enduranceIslandRaids[currentIsland][currentRaid].monsters
    local spawnRadius = self.config.spawnRadius
    local maxMobs = self.enduranceIslandRaids[currentIsland][currentRaid].maxMobs

    for __, spawn in ipairs(self.enduranceIslandAreas[currentIsland].monsterSpawns) do
        for i=1, maxMobs do
            local positionMob = getRandomCloseFreePosition(Position(spawn.x + sendRandom(spawnRadius), spawn.y + sendRandom(spawnRadius), spawn.z))
            local monster = Game.createMonster(mobs[math.random(#mobs)], positionMob, false, true)
                if monster then
                    self.monsterIds[monster:getId()] = 1
                end
        end
    end

    -- spawn boss
    if self.currentRaid.currentWave == self.enduranceIslandRaids[currentIsland][currentRaid].bossWave then
        local monster = Game.createMonster(self.enduranceIslandRaids[currentIsland][currentRaid].boss, self.enduranceIslandAreas[currentIsland].bossSpawnPos, false, true)
        monster:registerEvent("EnduranceBossKill")
        monster:setSkull(self.enduranceIslandRaids[currentIsland][currentRaid].skull)
        monster:setMaxHealth(monster:getMaxHealth() * self.enduranceIslandRaids[currentIsland][currentRaid].bossHealthMulti)
        monster:setHealth(monster:getMaxHealth())
        Game.broadcastMessage("The endurance island guardian has awoken!", MESSAGE_STATUS_WARNING)
    end
    if not (self.currentRaid.currentWave == self.enduranceIslandRaids[currentIsland][currentRaid].waves) then
        self.currentRaid.currentWave = self.currentRaid.currentWave + 1
        self.currentRaid.waveEvent = addEvent(g_enduranceIsland.spawnEnduranceIslandWave, self.config.timeBetweenWaves, self)
    else
        Game.broadcastMessage("The endurance island seems to be growing quietier...", MESSAGE_STATUS_WARNING)
    end
end


g_enduranceIsland.clearEnduranceIsland = function(self)
    --local centerPos = self.enduranceIslandAreas[self.currentRaid.currentIsland.type].centerPos
    --local xRange = self.enduranceIslandAreas[self.currentRaid.currentIsland.type].xRange
    --local yRange = self.enduranceIslandAreas[self.currentRaid.currentIsland.type].yRange

    --local mobsLeft = getSpectators(centerPos, xRange, yRange)

    --if mobsLeft ~= nil then
    --    for _, cid in pairs(mobsLeft) do
    --        local creature = Creature(cid)
    --        if not creature:isPlayer() then
    --            creature:remove()
    --        else
    --            creature:teleportTo(creature:getTown():getTemplePosition()) -- move the player to temple
   --         end
   --     end
   -- end

    for monsterId, _ in pairs(self.monsterIds) do
        local monster = Creature(monsterId)
        if monster then
            monster:remove()
        end
        self.monsterIds[monsterId] = nil -- make sure to delete entry from table to prevent memory leak
    end

    for playerId, _ in pairs(self.playerIds) do
        local player = Creature(playerId)
        if player then
            player:teleportTo(player:getTown():getTemplePosition())
        end
        self.playerIds[playerId] = nil -- make sure to delete entry from table to prevent memory leak
    end

    removeTeleport(self.config.teleportToIslandPos)

    self.currentRaid.activeRaid = false
    self.currentRaid.currentWave = 0
    self.currentRaid.currentIsland = {type = nil, index = 0}
    if g_enduranceIsland.currentRaid.waveEvent then
        stopEvent(g_enduranceIsland.currentRaid.waveEvent)
    end

    Game.broadcastMessage("The endurance island has fallen slient.", MESSAGE_STATUS_WARNING)
end

-- add island picking later
g_enduranceIsland.trySpawnEnduranceIsland = function(self)
    if Game.getPlayerCount() < self.config.requiredNumOfPlayers then
        return false
    end

    if self.currentRaid.activeRaid == true then
        stopEvent(g_enduranceIsland.currentRaid.clearEvent)
        stopEvent(g_enduranceIsland.currentRaid.waveEvent)
        self:clearEnduranceIsland()
    end

    -- re-enable if average level starts being used
    --local totalLevel = 0
    --local players = Game.getPlayers()
    --for _, player in ipairs(players) do
    --    totalLevel = totalLevel + player:getLevel()
	--end
    -- local averageLevel = totalLevel / #players -- average level to be considered later

    --if island then
    --    self.currentRaid.currentIsland.type = island.type
    --    self.currentRaid.currentIsland.index = island.index
    --else
    self.currentRaid.currentIsland.type = self.enduranceIslandTypes[math.random(1,4)]
    self.currentRaid.currentIsland.index = math.random(1, #self.enduranceIslandRaids[self.currentRaid.currentIsland.type])
    --end

    local enduranceIslandName = self.enduranceIslandRaids[self.currentRaid.currentIsland.type][self.currentRaid.currentIsland.index].name

    if not enduranceIslandName then
        return false
    end

    Game.broadcastMessage("The endurance island has awoken! " .. enduranceIslandName .. " has invaded the island!", MESSAGE_STATUS_WARNING)

    --createTeleport(self.config.teleportToIslandPos, self.enduranceIslandAreas[self.currentRaid.currentIsland.type].teleportPos)

    local teleportItem = Game.createItem(self.config.teleportId, 1, self.config.teleportToIslandPos)
    teleportItem:setDestination(self.enduranceIslandAreas[self.currentRaid.currentIsland.type].teleportPos)
    teleportItem:setActionId(self.config.playerInIslandTrackerActionId)

    self.currentRaid.activeRaid = true
    self.currentRaid.currentWave = 1
    self:spawnEnduranceIslandWave()

    self.currentRaid.clearEvent = addEvent(g_enduranceIsland.clearEnduranceIsland, self.config.islandTotalTimer, self)

    return true
end


function onThink(...)
    g_enduranceIsland:trySpawnEnduranceIsland()
	return true
end