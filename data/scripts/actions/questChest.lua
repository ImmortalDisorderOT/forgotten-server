
local advanceChest = Action()

function advanceChest.onUse(player, item, fromPosition, itemEx, toPosition)
    -----------------------------------------------------------------------------------
    -- Local Variables --
    -----------------------------------------------------------------------------------
    local questChestId = item:getUniqueId()
    if not questChests[questChestId] then
        return true
    end
    -----------------------------------------------------------------------------------
    -- Check if player has already opened box --
    -----------------------------------------------------------------------------------
    if player:getStorageValue(questChestId) == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
        toPosition:sendMagicEffect(10)
        return true
    end

    -----------------------------------------------------------------------------------
    -- Check if player has already opened box multiple chest only 1 reward --
    -----------------------------------------------------------------------------------
    if player:getStorageValue(questChests[questChestId].storageUnique) == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
        toPosition:sendMagicEffect(10)
        return true
    end 
    
    -----------------------------------------------------------------------------------
    -- Check if player meets level requirment
    -----------------------------------------------------------------------------------
    local playerLevel = player:getLevel()

    minLevel = questChests[questChestId].minLevel or 0
    if playerLevel < minLevel then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be atleast level ".. questChests[questChestId].minLevel.." to open this chest.")
        return true
    end
    -----------------------------------------------------------------------------------
    -- Give reward if player has not yet opened box --
    -----------------------------------------------------------------------------------
    for i = 1, #questChests[questChestId].rewards do
        local rewardType = questChests[questChestId].rewards[i].type

        -----------------------------------------------------------------------------------
        -- Item Type Reward --
        -----------------------------------------------------------------------------------
        if rewardType == "item" then
                local itemid = questChests[questChestId].rewards[i].itemid
                local count = math.max(0, questChests[questChestId].rewards[i].count)

                player:addItem(itemid, count)
                if count > 0 then
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You earned " .. count .."x "  .. getItemName(itemid) .. "s")
                else 
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You earned a(n) "  .. getItemName(itemid))
                end
        end

        -----------------------------------------------------------------------------------
        -- Experience Type Reward --
        -----------------------------------------------------------------------------------
        if rewardType == "experience" then
            local amount = questChests[questChestId].rewards[i].amount
            player:addExperience(amount)
            player:say(amount.." EXP gained!", TALKTYPE_MONSTER_SAY)
            player:getPosition():sendMagicEffect(CONST_ME_STUN)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You gained "..amount.." experience points.")
        end

        -----------------------------------------------------------------------------------
        -- Outfit Type Reward --
        -----------------------------------------------------------------------------------
        if rewardType == "outfit" then
            local outfitName = questChests[questChestId].rewards[i].name
            local maleOutfit = questChests[questChestId].rewards[i].maleId
            local femaleOutfit = questChests[questChestId].rewards[i].femaleId
            if player:getSex() == 0 then
                player:addOutfit(femaleOutfit)
            else
                player:addOutfit(maleOutfit)
            end
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You gained the "..outfitName.." outfit.")
        end

        -----------------------------------------------------------------------------------
        -- Addon Type Reward --
        -----------------------------------------------------------------------------------
        if rewardType == "addon" then
            local outfitName = questChests[questChestId].rewards[i].outfit
            local addon = questChests[questChestId].rewards[i].addonNumber
            local maleAddon = questChests[questChestId].rewards[i].maleId
            local femaleAddon = questChests[questChestId].rewards[i].femaleId
            if player:getSex() == 0 then
                player:addOutfitAddon(femaleAddon, addon)
            else
                player:addOutfitAddon(maleAddon, addon)
            end
            if addon == 1 then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You gained the first "..outfitName.." outfit addon.")
            elseif addon == 2 then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You gained the second "..outfitName.." outfit addon.")
            elseif addon == 3 then
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You gained the third "..outfitName.." outfit addon.")
            end
        end

        -----------------------------------------------------------------------------------
        -- Mount Type Reward --
        -----------------------------------------------------------------------------------
        if rewardType == "mount" then
            local mountName = questChests[questChestId].rewards[i].mountName
            local mountId = questChests[questChestId].rewards[i].mountId
            player:addMount(mountId)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You have unlocked the "..mountName.." mount.")
        end

        -----------------------------------------------------------------------------------
        -- Title Type Reward --
        -----------------------------------------------------------------------------------
        if rewardType == "title" then
            local titleName = questChests[questChestId].rewards[i].titleName
            local titleId = questChests[questChestId].rewards[i].titleId
            player:addTitle(titleId)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You have unlocked the "..titleName.." title.")
        end
        -----------------------------------------------------------------------------------
        -- Add in any cooldowns/storages --
        -----------------------------------------------------------------------------------
        player:setStorageValue(questChestId, 1)
        player:setStorageValue(questChests[questChestId].storageUnique, 1)
    end

    return true
end

for i = 48000, 49000 do
    advanceChest:uid(i)
end

advanceChest:register()