local talk = TalkAction("/globalboost", "!globalboost")

local config = {
    ['exp'] = {skillKey = 17585, timeKey = 17589},
    ['skill'] = {skillKey = 17586, timeKey = 17590},
    ['orb'] = {skillKey = 17587, timeKey = 17591}
}

function talk.onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local split = param:split(",")
    if split[3] == nil then
        player:sendCancelMessage("Insufficient parameters [(exp,skill,orb),percentage,hours].")
        return false
    end
    
    local skillName = split[1]
    local percentage = tonumber(split[2])
    local hours = tonumber(split[3])
    
    local globalStorage = config[skillName]
    if not globalStorage then
        player:sendCancelMessage("Skill name value must be one of the following: exp, skill, orb.")
        return false
    end

    if percentage <= 0 then
        player:sendCancelMessage("Percentage value must be higher than 0. For example, 50% means 1.5x higher rate.")
        return false
    end
    
    if hours <= 0 then
        player:sendCancelMessage("Hours value must be higher than 0.")
        return false
    end
    
    setGlobalStorageValue(globalStorage.skillKey, percentage)
    setGlobalStorageValue(globalStorage.timeKey, os.time() + hours * 60 * 60)
    broadcastMessage(player:getName() .. " has activated a global " .. percentage .. "% " .. skillName .. " rate boost for the next " .. hours .. " " .. (hours == 1 and "hour" or "hours") .. ".", MESSAGE_STATUS_WARNING)
    
    return false
end

talk:separator(" ")
talk:register()
