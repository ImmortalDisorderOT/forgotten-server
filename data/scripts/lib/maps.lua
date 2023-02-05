ACTIVEMAPS = {}


mapsArea = {topLeft = Position(4000, 4000, 7),
            bottomRight = Position(5000, 5000, 7),
            sizeX = 200,
            sizeY = 200,
            instances = {   [1] = {
                                    active = false,
                                    offsetX = 0,
                                    offsetY = 0
                            },
                            [2] = {
                                    active = false,
                                    offsetX = 200,
                                    offsetY = 0
                            },
                            [3] = {
                                    active = false,
                                    offsetX = 400,
                                    offsetY = 0
                            }
            }
        }


mapIds = { -- indexed this way to save time later, little bit extra memory for saved time, can disable maps by having the mapID = false
        [39713] = true, -- Beach map
        [43193] = true, -- Deep Mire
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
                    }
                },
        [43193] = {     name = "Deep Mire",
                        filename = "deep_mire",
                        tier = 1,
                        teleportToPos = Position(116, 44, 7),
                        teleportOutCreatePos = Position(115, 41, 7),
                        multiFloor = false,
                        mobs = {"orc", "orc spearman"},
                        spawns = {
                                    {
                                        position = Position(99, 72, 7),
                                        radius = 3,
                                        maxMobs = 6
                                    },
                                    {
                                        position = Position(117, 76, 7),
                                        radius = 3,
                                        maxMobs = 7
                                    },
                                    {
                                        position = Position(91, 40, 7),
                                        radius = 3,
                                        maxMobs = 6
                                    },
                                    {
                                        position = Position(92, 54, 7),
                                        radius = 2,
                                        maxMobs = 3,
                                    },
                                    {
                                        position = Position(78, 66, 7),
                                        radius = 4,
                                        maxMobs = 8
                                    },
                                    {
                                        position = Position(65, 40, 7),
                                        radius = 3,
                                        maxMobs = 4
                                    },
                                    {
                                        position = Position(65, 24, 7),
                                        radius = 3,
                                        maxMobs = 7
                                    },
                                    {
                                        position = Position(54, 34, 7),
                                        radius = 3,
                                        maxMobs = 6
                                    },
                                    {
                                        position = Position(18, 68, 7),
                                        radius = 3,
                                        maxMobs = 6
                                    },
                                    {
                                        position = Position(34, 43, 7),
                                        radius = 3,
                                        maxMobs = 7
                                    },
                                    {
                                        position = Position(25, 31, 7),
                                        radius = 4,
                                        maxMobs = 8
                                    }        
                        },
                        boss = "orc warlord",
                        bossSpawn = Position(20, 35, 7)

        }
}
