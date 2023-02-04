
OPCODE_STATS = 60

-- Stats are given every level, starting from level 8 (stats = level - 8)


function getPlayerStats(player)
    local data = {int = 0, str = 0, vit = 0, dex = 0, unallocated = 0}

    data.int = player:getStorageValue(PlayerStorageKeys.statsInt)
    data.str = player:getStorageValue(PlayerStorageKeys.statsStr)
    data.vit = player:getStorageValue(PlayerStorageKeys.statsVit)
    data.dex = player:getStorageValue(PlayerStorageKeys.statsDex)
    data.unallocated = player:getStorageValue(PlayerStorageKeys.unallocatedStats)

    return data
end

function verifyStatsCount(player)
    local data = getPlayerStats(player)

    local totalStats = math.max(player:getLevel() - 8, 0) -- stats amount that is expected
    local buffer = 0 -- actual stats amount
    for i, val in pairs(data) do
        buffer = buffer + val
        if val < 0 then
            forceResetStats(player, totalStats)
            return true
        end
    end

    if buffer > totalStats  or buffer < totalStats then
        forceResetStats(player, totalStats)
        return true
    end

    return true
end

function allocateStat(player, stat, val)
    val = val or 1

    if stat == "reset" then
        resetStats(player)
        return true
    end

    if player:getStorageValue(PlayerStorageKeys.unallocatedStats) > 0 then
        -- allocate the stat
        if stat == "str" then
            player:setStorageValue(PlayerStorageKeys.statsStr, (player:getStorageValue(PlayerStorageKeys.statsStr) + val))
            player:setStorageValue(PlayerStorageKeys.unallocatedStats, (player:getStorageValue(PlayerStorageKeys.unallocatedStats) - val))
        elseif stat == "vit" then
            player:setStorageValue(PlayerStorageKeys.statsVit, (player:getStorageValue(PlayerStorageKeys.statsVit) + val))
            player:setStorageValue(PlayerStorageKeys.unallocatedStats, (player:getStorageValue(PlayerStorageKeys.unallocatedStats) - val))
        elseif stat == "int" then
            player:setStorageValue(PlayerStorageKeys.statsInt, (player:getStorageValue(PlayerStorageKeys.statsInt) + val))
            player:setStorageValue(PlayerStorageKeys.unallocatedStats, (player:getStorageValue(PlayerStorageKeys.unallocatedStats) - val))
        elseif stat == "dex" then
            player:setStorageValue(PlayerStorageKeys.statsDex, (player:getStorageValue(PlayerStorageKeys.statsDex) + val))
            player:setStorageValue(PlayerStorageKeys.unallocatedStats, (player:getStorageValue(PlayerStorageKeys.unallocatedStats) - val))
        end
        return true
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are at max stats for your level already.")
        return false
    end
end

function forceResetStats(player, totalStats)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Something went wrong with your stats, please re-allocate them.")
    player:setStorageValue(PlayerStorageKeys.statsInt, 0)
    player:setStorageValue(PlayerStorageKeys.statsStr, 0)
    player:setStorageValue(PlayerStorageKeys.statsVit, 0)
    player:setStorageValue(PlayerStorageKeys.statsDex, 0)
    player:setStorageValue(PlayerStorageKeys.unallocatedStats, totalStats)
end

function resetStats(player)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Stats resetted")
    player:setStorageValue(PlayerStorageKeys.statsInt, 0)
    player:setStorageValue(PlayerStorageKeys.statsStr, 0)
    player:setStorageValue(PlayerStorageKeys.statsVit, 0)
    player:setStorageValue(PlayerStorageKeys.statsDex, 0)
    player:setStorageValue(PlayerStorageKeys.unallocatedStats, math.max(player:getLevel() - 8, 0))
end

