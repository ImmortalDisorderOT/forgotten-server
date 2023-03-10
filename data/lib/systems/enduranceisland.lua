if not g_enduranceIsland then
    g_enduranceIsland = {
      currentRaid = {
        activeRaid = false,
        currentWave = 0,
        currentIsland = {type = nil, index = 0},
        clearEvent = nil,
        waveEvent = nil,
        monstersAlive = 0,
      },
      enduranceIslandTypes = {"sandisland", "fireisland", "iceisland", "grassisland"},
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
    exitPos = Position(1163, 1119, 7)
}

-- change raid monster/bosses here
g_enduranceIsland.enduranceIslandRaids = {
    ["sandisland"] = {
        [1] = {
            name = "Undeads",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 10,
            monsters = {"ghoul", "skeleton", "skeleton warrior"},
            maxMobs = 8, -- max mobs per spawn orb
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
            maxMobs = 6, -- max mobs per spawn orb
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
            maxMobs = 8, -- max mobs per spawn orb
            boss = "general murius",
            skull = SKULL_BLACK,
            bossWave = 8,
            bossHealthMulti = 15,
        },
        [3] = {
            name = "Pharaohs",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"ashmunrah", "dipthrah", "mahrdis", "morguthis", "omruc", "rahemos", "thalas", "vashresamun"},
            maxMobs = 7, -- max mobs per spawn orb
            boss = "the ravager",
            skull = SKULL_RED,
            bossWave = 10,
            bossHealthMulti = 15,
        }
    },
    ["fireisland"] = {
        [1] = {
            name = "Dragons",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 10,
            monsters = {"dragon hatchling", "dragon lord hatchling", "dragon", "dragon lord"},
            maxMobs = 6, -- max mobs per spawn orb
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
            maxMobs = 7, -- max mobs per spawn orb
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
            maxMobs = 6, -- max mobs per spawn orb
            boss = "orshabaal",
            skull = SKULL_WHITE,
            bossWave = 10,
            bossHealthMulti = 15,
        },
        [4] = {
            name = "A Threat to Civilization",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"choking fear", "minion of gaz'haragoth", "retching horror", "guzzlemaw"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "gaz'haragoth",
            skull = SKULL_WHITE,
            bossWave = 10,
            bossHealthMulti = 15,
        },
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
            maxMobs = 6, -- max mobs per spawn orb
            boss = "frost dragon",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 10,
        },
        [3] = {
            name = "Frost Dragons",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"frost dragon", "ice dragon", "frost dragon hatchling"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "gelidrazah the frozen",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 15,
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
            name = "Elite Orcs",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"orc berserker", "orc shaman", "orc rider", "orc leader"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "orc warlord",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 20,
        },
        [4] = {
            name = "Swamp Monsters",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"bog raider", "giant spider", "devourer"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "defiler",
            skull = SKULL_BLACK,
            bossWave = 10,
            bossHealthMulti = 15,
        },   
        [5] = {
            name = "Wizards",
            requiredLevel = {min = 0, max = 1}, -- for use when implemented
            waves = 15,
            monsters = {"warlock", "necromancer", "infernalist"},
            maxMobs = 6, -- max mobs per spawn orb
            boss = "ferumbras",
            skull = SKULL_WHITE,
            bossWave = 10,
            bossHealthMulti = 15,
        },
    }
}

-- only edit if island changes
g_enduranceIsland.enduranceIslandAreas = {
    ["sandisland"] = {
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
            Position(1363, 934, 7),
            Position(1364, 927, 7),
            Position(1370, 926, 7),
            Position(1364, 956, 7),
            Position(1371, 1008, 7),
            Position(1350, 1015, 7),
        },
    },
    ["iceisland"] = {
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
                monster:registerEvent("EnduranceMonsterKill")
                self.monsterIds[monster:getId()] = 1
                self.currentRaid.monstersAlive = self.currentRaid.monstersAlive + 1
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
        self.monsterIds[monster:getId()] = 1
        Game.broadcastMessage(string.format("The Endurance Island Guardian, %s has awoken!", monster:getName()), MESSAGE_STATUS_WARNING)
    end
    if not (self.currentRaid.currentWave == self.enduranceIslandRaids[currentIsland][currentRaid].waves) then
        self.currentRaid.currentWave = self.currentRaid.currentWave + 1
        self.currentRaid.waveEvent = addEvent(g_enduranceIsland.spawnEnduranceIslandWave, self.config.timeBetweenWaves, self)
    else
        Game.broadcastMessage("The Endurance Island seems to be growing quieter...", MESSAGE_STATUS_WARNING)
    end
end


g_enduranceIsland.clearEnduranceIsland = function(self)
    for monsterId, _ in pairs(self.monsterIds) do
        local monster = Creature(monsterId)
        if monster then
            monster:remove()
        end
        self.monsterIds[monsterId] = nil
    end

    for playerId, _ in pairs(self.playerIds) do
        local player = Player(playerId)
        if player then
            player:teleportTo(player:getTown():getTemplePosition())
        end
        self.playerIds[playerId] = nil
    end

    removeTeleport(self.config.teleportToIslandPos)

    self.currentRaid.activeRaid = false
    self.currentRaid.currentWave = 0
    self.currentRaid.currentIsland = {type = nil, index = 0}
    self.currentRaid.monstersAlive = 0
    if g_enduranceIsland.currentRaid.waveEvent then
        stopEvent(g_enduranceIsland.currentRaid.waveEvent)
    end

    Game.broadcastMessage("The Endurance Island has fallen slient.", MESSAGE_STATUS_WARNING)
end

g_enduranceIsland.closeEnduranceIsland = function(self, data)
    self:clearEnduranceIsland()
    local tile = Tile(data.bossTeleportPos)
    if tile then
        local teleport = tile:getItemById(1387)
        if teleport then
            teleport:remove()
        end
    end
end

-- add island picking later
g_enduranceIsland.spawnEnduranceIsland = function(self)
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
        print("name")
        return false
    end

    Game.broadcastMessage("The endurance island has awoken! " .. enduranceIslandName .. " has invaded the island!", MESSAGE_STATUS_WARNING)

    local teleportItem = Game.createItem(self.config.teleportId, 1, self.config.teleportToIslandPos)
    teleportItem:setActionId(self.config.playerInIslandTrackerActionId)

    self.currentRaid.activeRaid = true
    self.currentRaid.currentWave = 1
    self:spawnEnduranceIslandWave()

    self.currentRaid.clearEvent = addEvent(g_enduranceIsland.clearEnduranceIsland, self.config.islandTotalTimer, self)

    return true
end

g_enduranceIsland.onBossDeath = function(self, creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local teleportPos = creature:getPosition()
    teleportPos = getRandomCloseFreePosition(teleportPos) -- using random close free position so it doesnt spawn ON the boss (causing the corpse to teleport)
    createTeleport(teleportPos, self.config.rewardRoomPosition)
    Game.broadcastMessage(string.format("The Endurance Island boss (%s) has been slain! A reward room teleport has been created but it will disappear in %s!", creature:getName(), formatTime(self.config.islandEndTimer)), MESSAGE_STATUS_WARNING)
    self.monsterIds[creature:getId()] = nil

    addEvent(g_enduranceIsland.closeEnduranceIsland, self.config.islandEndTimer, self, {bossTeleportPos = teleportPos})
    return true
end

g_enduranceIsland.onMonsterDeath = function(self, creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    self.monsterIds[creature:getId()] = nil
    self.currentRaid.monstersAlive = math.max(self.currentRaid.monstersAlive - 1, 0)
    creature:say(string.format("%d Monsters left.", self.currentRaid.monstersAlive), TALKTYPE_MONSTER_SAY)
    return true
end

-- this one is handled on default player.OnDeath 
g_enduranceIsland.onDeath = function(self, player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    self.playerIds[player:getId()] = nil
    return true
end

g_enduranceIsland.addPlayer = function(self, player)
    self.playerIds[player:getId()] = 1
    player:teleportTo(self.enduranceIslandAreas[self.currentRaid.currentIsland.type].teleportPos, true)
end

g_enduranceIsland.removePlayer = function(self, player)
    self.playerIds[player:getId()] = nil
    player:teleportTo(self.config.exitPos, true)
end