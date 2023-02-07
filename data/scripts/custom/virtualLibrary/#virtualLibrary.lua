
local action_virtualLibrary = Action()

function action_virtualLibrary.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local actionId = item:getActionId()
    for i = 1, #virtualLibrary do
        if virtualLibrary[i][1] == actionId then
            if player:getStorageValue(actionId) == 1 then
                player:sendTextMessage(MESSAGE_STATUS_SMALL, "You've commited this book to your virtual library already.")
                return true
            end
            player:setStorageValue(actionId, 1)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You've found " .. virtualLibrary[i][3] .. ". This book is now available in your virtual library.")
            break
        end
    end    
    return true
end

for i = 1, #virtualLibrary do
    action_virtualLibrary:aid(virtualLibrary[i][1])
end
action_virtualLibrary:register()



local talkaction_virtualLibrary = TalkAction("/readfromlibrary", "!readfromlibrary")

function talkaction_virtualLibrary.onSay(player, words, param)
    if param == nil or param == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use /readfromlibrary list if you're unsure of the book title.")
        return false
    end
    local text = ""
    for i = 1, #virtualLibrary do
        if virtualLibrary[i][3]:lower() == param:lower() then
            if player:getStorageValue(virtualLibrary[i][1]) < 1 then
                break
            end
            player:showTextDialog(virtualLibrary[i][2], virtualLibrary[i][3] .. "\n\n" .. virtualLibrary[i][4])
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Accessing book: " .. virtualLibrary[i][3])
            return false
        end
        if param:lower() == "list" then
            if player:getStorageValue(virtualLibrary[i][1]) == 1 then
                if text ~= "" then
                    text = text .. "\n"
                end
                text = text .. virtualLibrary[i][3]
            end
        end
    end
    if param:lower() == "list" then
        if text == "" then
            text = "None."
        end
        player:showTextDialog(1950, "List of books in your virtual library:\n\n" .. text)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Accessing virtual library list.")
        return false
    end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Unable to find " .. param .. " in your virtual library.")
    return false
end

talkaction_virtualLibrary:separator(" ")
talkaction_virtualLibrary:register()