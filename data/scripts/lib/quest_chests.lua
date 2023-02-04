-- config for questChests found in actions/scripts/quest_chests

questChests = {
   [48000] = { -- Rotworm Cave Quest
        questMsg_success = "You have found 10000 gold.",
        levelReq = 0,
        item_reward = {
            [1] = {itemid = 2160, count = 1}
        }       
   }
   --[48000] = {
        --questStorage = 10000,
        --questStatus = 5,
        --questMsg_success = "You have found the item now go do blah blah blah",
        --questMsg_fail = "You are not ready to open this chest. Go do blah blah blah"
        --levelReq = 0,
        --keyReq = 2143,
        --expReward = 10000,
        --item_reward = {
        --    [1] = {itemid = 1111, count = 1},
        --    [2] = {itemid = 1111, count = 1}
        --},
        --outfit_reward = {
        --    [1] = {male = 111, female = 111, addons = 0}
        --},
        --addon_reward = {
        --[   1] = {male = 111, female = 111, addons = 1}
        --},
        --mount_reward = {
        --    [1] = {mountId = 1}
        --}
       
   --}
   
}
