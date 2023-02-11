-- config for questChests found in actions/scripts/quest_chests

-- example rewards
--[1] = {type = "item", item = 2160, count = 1, itemlevel = 0, itemrarity = 1}
-- rarites
--COMMON = 1
--RARE = 2
--EPIC = 3
--LEGENDARY = 4
--MYTHICAL = 5

--[2] = {type = "experience", amount = 20000}
--[3] = {type = "outfit", name = "assassin", femaleId = 156, maleId = 152}
--[4] = {type = "addon", outfit = "nobleman", addonNumber = 1, femaleId = 140, maleId = 132}
--[5] = {type = "mount", mountName = "Orc", mountId = 20}
--[6] = {type = "title", mountName = "Maxe Maniac", mountId = 1}

questChests = {
   [48000] = {
        levelReq = 0,
        storageUnique = 48000,
        rewards = {
            [1] = {type = "item", itemid = 2361, count = 0}
        }
   },
   [48001] = {
    levelReq = 0,
    storageUnique = 48001,
    rewards = {
        [1] = {type = "item", itemid = 2160, count = 15},
        [2] = {type = "experience", amount = 2000000},
        [3] = {type = "title", titleName = "Maze Maniac", titleId = 1}
        }
    },
     [48003] = {
      levelReq = 0,
      storageUnique = 48003,
      rewards = {
          [1] = {type = "item", itemid = 2400, count = 0, itemlevel = 100, itemrarity = 4}
         }
      },
      [48004] = {
       levelReq = 0,
       storageUnique =  48004,
       rewards = {
           [1] = {type = "item", itemid = 2400, count = 0}
          }
       }
}
