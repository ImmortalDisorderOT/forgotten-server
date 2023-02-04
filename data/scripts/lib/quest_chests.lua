-- config for questChests found in actions/scripts/quest_chests

-- example rewards
--[1] = {type = "item", item = 2160, count = 1}
--[2] = {type = "experience", amount = 20000}
--[3] = {type = "outfit", name = "assassin", femaleId = 156, maleId = 152}
--[4] = {type = "addon", outfit = "nobleman", addonNumber = 1, femaleId = 140, maleId = 132}
--[5] = {type = "mount", mountName = "Orc", mountId = 20}

questChests = {
   [48000] = {
        levelReq = 0,
        storageUnique = 48000,
        rewards = {
            [1] = {type = "item", itemid = 2361, count = 0}
        }
   }
}
