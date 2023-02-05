-- lib for orb looting, found in onDeath_orbLoot.lua

orbs = {
            { -- tier 1
                levelmin = 1, -- level of 0 will never give orbs
                levelmax = 1,
                orblist = {
                    {
                        type = "loot",
                        chance = 15,
                        text = "Items!",
                        effect = CONST_ME_ENERGYHIT, 
                        tiers = {
                                -- A random number is rolled between 1 to 10000. 
                                -- [chance_lower, chance_higher] = {itemList = {itemid, amount_min, amount_max, chance} } chance is always out of 10000
                                -- If the number is between or equal to chance_lower, chance_higher, that tier is selected.
                                -- note; DO NOT SET amount_min, amount_max higher then 1, if that item is not stackable.
                                -- note; Even though a reward tier has been selected, if all item chances fail to reward an item, it's possible that a player will not receive any item. 
                                --       for that reason, it is suggested that at least 1 item's chance is set to 10000, so that a player is guaranteed to receive an item.
                                [{  1,  5000}] = {itemList = {
                                        {2148, 1, 1, 10000},
                                        {2148, 2, 2, 5000}, 
                                        {2148, 3, 3, 5000}
                                    }
                                },
                                [{5001,  8500}] = {itemList = {
                                        {2148, 1, 1, 10000},
                                        {2148, 2, 2, 5000}, 
                                        {2148, 3, 3, 5000}
                                    }
                                },
                                [{8501,  9500}] = {itemList = {
                                        {2148, 1, 1, 10000},
                                        {2148, 2, 2, 5000}, 
                                        {2148, 3, 3, 5000} 
                                    }
                                },
                                [{9501, 10000}] = {itemList = {
                                        {2148, 1, 1, 10000},
                                        {2148, 2, 2, 5000},
                                        {2148, 3, 3, 5000}
                                    }
                                }
                        }
                    },
                    {
                        type = "gold",
                        chance = 10,
                        text = "Money!",
                        effect = CONST_ME_HOLYAREA,
                        min = 10,  -- min money gained
                        max = 100 -- max money gained
                    },
                    {
                        type = "experience",
                        chance = 5,
                        text = "EXP!",
                        effect = CONST_ME_FIREAREA,
                        min = 10, -- min exp gained
                        max = 100 -- max exp gained
                    }
                }   
            },
            { 
                levelmin = 5, 
                levelmax = 10,
                orblist = {
                    {
                        type = "gold",
                        chance = 10,
                        text = "Money!",
                        effect = CONST_ME_HOLYAREA,
                        min = 50,  -- min money gained
                        max = 100 -- max money gained
                    },

                    {
                        type = "experience",
                        chance = 5,
                        text = "EXP!",
                        effect = CONST_ME_FIREAREA,
                        min = 100, -- min exp gained
                        max = 200 -- max exp gained
                    }
                }
            },
            { 
                levelmin = 11, 
                levelmax = 15,
                orblist = {
                    {
                        type = "gold",
                        chance = 10,
                        text = "Money!",
                        effect = CONST_ME_HOLYAREA,
                        min = 80,  -- min money gained
                        max = 140 -- max money gained
                    },

                    {
                        type = "experience",
                        chance = 5,
                        text = "EXP!",
                        effect = CONST_ME_FIREAREA,
                        min = 150, -- min exp gained
                        max = 225 -- max exp gained
                    }
                }
            },
            { 
                levelmin = 16, 
                levelmax = 16,
                orblist = {
                    {
                        type = "gold",
                        chance = 80,
                        text = "Money!",
                        effect = CONST_ME_HOLYAREA,
                        min = 250,  -- min money gained
                        max = 300 -- max money gained
                    },

                    {
                        type = "experience",
                        chance = 80,
                        text = "EXP!",
                        effect = CONST_ME_FIREAREA,
                        min = 400, -- min exp gained
                        max = 500 -- max exp gained
                    }
                }
            }
}
