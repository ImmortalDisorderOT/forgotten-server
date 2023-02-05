-- lib for orb looting, found in onDeath_orbLoot.lua

orbs = {
            { 
                levelmin = 0,
                levelmax = 10000,
                orblist = {
                    {
                        type = "loot",
                        chance = 50,
                        text = "Crystals!",
                        effect = 222,
                        tiers = {
                                -- A random number is rolled between 1 to 10000. 
                                -- [chance_lower, chance_higher] = {itemList = {itemid, amount_min, amount_max, chance} } chance is always out of 10000
                                -- If the number is between or equal to chance_lower, chance_higher, that tier is selected.
                                -- note; DO NOT SET amount_min, amount_max higher then 1, if that item is not stackable.
                                -- note; Even though a reward tier has been selected, if all item chances fail to reward an item, it's possible that a player will not receive any item. 
                                --       for that reason, it is suggested that at least 1 item's chance is set to 10000, so that a player is guaranteed to receive an item.
                                [{  1,  5000}] = {itemList = {
                                        {42929, 1, 3, 10000}
                                    }
                                },
                                [{5001,  10000}] = {itemList = {
                                        {42929, 2, 6, 10000}
                                    }
                                }
                        }
                    },
                    {
                        type = "gold",
                        chance = 25,
                        text = "Money!",
                        effect = 224,
                        min = 500,  -- min money gained
                        max = 5000 -- max money gained
                    }
                }   
            }
}
