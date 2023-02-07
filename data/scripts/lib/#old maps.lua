ACTIVEMAPS = {}


mapsArea = {topLeft = Position(1335, 1068, 7),
            bottomRight = Position(1402, 1106, 7)}


mapIds = { -- indexed this way to save time later, little bit extra memory for saved time, can disable maps by removing their entry here
        [39713] = true -- Beach map
}

maps = {
        [39713] ={ {	name = "Beach",
                        tier = 1, -- may or may not be used?
                        active = false,
                        teleportToPos = Position(1341, 1076, 7), -- where the teleport inital position will be
                        teleportOutCreatePos = Position(1340, 1075, 7), -- will the "exit" portal will be
                        centerPos = Position(1350, 1080, 7), -- used for clearing
                        mapRangeX = 10, -- used for clearing
                        mapRangeY = 6, -- used for clearing
                        multiFloor = false, -- used for clearing
                        mobs = {"orc", "orc spearman"}, -- it'll take  a random mob each spawn, probably don't have  more then 2~3 mobs in here
                        spawns = {
                                    {   position = Position(1344, 1078, 7),
                                        radius = 2,
                                        maxMobs = 6
                                    },
                                    {   position = Position(1355, 1078, 7),
                                        radius = 2,
                                        maxMobs = 3
                                    },
                                    {   position = Position(1350, 1083, 7),
                                        radius = 2,
                                        maxMobs = 2
                                    },
                                }, 
                        boss = "orc warlord", -- boss monster
                        bossSpawn = Position(1344, 1078, 7) -- location for the boss
                    },
                    {	name = "Beach",
                        tier = 1, -- may or may not be used?
                        active = false,
                        teleportToPos = Position(1372, 1076, 7), -- where the teleport inital position will be
                        teleportOutCreatePos = Position(1371, 1075, 7), -- will the "exit" portal will be
                        centerPos = Position(1381, 1080, 7), -- used for clearing
                        mapRangeX = 10, -- used for clearing
                        mapRangeY = 6, -- used for clearing
                        multiFloor = false, -- used for clearing
                        mobs = {"orc", "orc spearman"}, -- it'll take  a random mob each spawn, probably don't have  more then 2~3 mobs in here
                        spawns = {
                                    {   position = Position(1375, 1078, 7),
                                        radius = 2,
                                        maxMobs = 6
                                    },
                                    {   position = Position(1385, 1078, 7),
                                        radius = 2,
                                        maxMobs = 3
                                    },
                                    {   position = Position(1365, 1083, 7),
                                        radius = 2,
                                        maxMobs = 2
                                    },
                                }, 
                        boss = "orc warlord", -- boss monster
                        bossSpawn = Position(1375, 1078, 7) -- location for the boss
                    },
                    {	name = "Beach",
                        tier = 1, -- may or may not be used?
                        active = false,
                        teleportToPos = Position(1341, 1092, 7), -- where the teleport inital position will be
                        teleportOutCreatePos = Position(1340, 1091, 7), -- will the "exit" portal will be
                        centerPos = Position(1350, 1096, 7), -- used for clearing
                        mapRangeX = 10, -- used for clearing
                        mapRangeY = 6, -- used for clearing
                        multiFloor = false, -- used for clearing
                        mobs = {"orc", "orc spearman"}, -- it'll take  a random mob each spawn, probably don't have  more then 2~3 mobs in here
                        spawns = {
                                    {   position = Position(1344, 1095, 7),
                                        radius = 2,
                                        maxMobs = 6
                                    },
                                    {   position = Position(1355, 1095, 7),
                                        radius = 2,
                                        maxMobs = 3
                                    },
                                    {   position = Position(1350, 1099, 7),
                                        radius = 2,
                                        maxMobs = 2
                                    },
                                }, 
                        boss = "orc warlord", -- boss monster
                        bossSpawn = Position(1344, 1095, 7) -- location for the boss
                    },
                    {	name = "Beach",
                        tier = 1, -- may or may not be used?
                        active = false,
                        teleportToPos = Position(1372, 1092, 7), -- where the teleport inital position will be
                        teleportOutCreatePos = Position(1371, 1091, 7), -- will the "exit" portal will be
                        centerPos = Position(1381, 1096, 7), -- used for clearing
                        mapRangeX = 10, -- used for clearing
                        mapRangeY = 6, -- used for clearing
                        multiFloor = false, -- used for clearing
                        mobs = {"orc", "orc spearman"}, -- it'll take  a random mob each spawn, probably don't have  more then 2~3 mobs in here
                        spawns = {
                                    {   position = Position(1376, 1095, 7),
                                        radius = 2,
                                        maxMobs = 6
                                    },
                                    {   position = Position(1384, 1095, 7),
                                        radius = 2,
                                        maxMobs = 3
                                    },
                                    {   position = Position(1381, 1099, 7),
                                        radius = 2,
                                        maxMobs = 1
                                    },
                                }, 
                        boss = "orc warlord", -- boss monster
                        bossSpawn = Position(1381, 1099, 7) -- location for the boss
                    }
                }
}
