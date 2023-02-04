local talk = TalkAction("/setportal", "!setportal")

function talk.onSay(player, words, param)
    if ACTIVEMAPS[player:getId()] ~= nil then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You cannot change your portal type with a map active")
        return false
    end

    if TOWN_PORTALS_PLAYERS[player:getId()] ~= nil then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You cannot change your portal type with a town portal active")
        return false
    end
    if param ~= "" and table.contains(possiblePortals, tonumber(param)) then
        player:setStorageValue(PlayerStorageKeys.teleportType, param)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your portal type has been set to: " .. param)
    else
        local message = "Possible portal ids are:"
        for i, val in pairs(possiblePortals) do
            message = message .. " " .. val
        end
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, message)
    end
    return false
end

talk:separator(" ")
talk:register()
