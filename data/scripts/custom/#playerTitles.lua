
TitlesAvailable = { [1] = "Test",
                    [2] = "Test2"}

colorsAvailable = { [1] = "blue",
                    [2] = "green",
                    [3] =  "red",
                    [4] = "yellow",
                    [5] = "white"}

PLAYERTITLES = {}



TITLES_OPCODE = 65


local function sendNewTitleToAllPlayers(playerName, titleId, color)
    local players = Game.getPlayers()
    for i, player in pairs(players) do
        if player then
            local msg = {request = "update", name = playerName, title = titleId, color = color}
            player:sendExtendedOpcode(TITLES_OPCODE, json.encode(msg))
        end
    end
end

local function clearTitleForAllPlayers(playerName)
    local players = Game.getPlayers()
    for i, player in pairs(players) do
        if player then
            local msg = {request = "remove", name = playerName}
            player:sendExtendedOpcode(TITLES_OPCODE, json.encode(msg))
        end
    end
end

-- Register the creature event for player

local playerTitleLoginEvent = CreatureEvent()
playerTitleLoginEvent:type("login")

function playerTitleLoginEvent.onLogin(player)

    player:registerEvent("playerTitlesOpCodeEvent")

    if player:getStorageValue(PlayerStorageKeys.playerTitle) == -1 then
         player:setStorageValue(PlayerStorageKeys.playerTitle, 0)
    end

    local checkTitle = player:getStorageValue(PlayerStorageKeys.playerTitle)
    local checkColor = player:getStorageValue(PlayerStorageKeys.playerTitleColor)
    if not PLAYERTITLES[player:getName()] and checkTitle > 0 and checkColor > 0 then -- player title has not been sent to everyone yet
        if TitlesAvailable[checkTitle] then -- title is available
            PLAYERTITLES[player:getName()] = {titleId = checkTitle, color = colorsAvailable[checkColor]}
            sendNewTitleToAllPlayers(player:getName(), checkTitle, colorsAvailable[checkColor]) -- sending one new title to everyone, the title of the player who just logged in
        elseif checkTitle ~= 0 then -- title is not available, and the check title isnt set to 0 (default value)
            player:setStorageValue(PlayerStorageKeys.playerTitle, 0)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Something went wrong with your title, and it has been reset.")
            PLAYERTITLES[player:getName()] = nil
        end
    end
    return true
end

playerTitleLoginEvent:register()


local function sendTitleInfo(player)
	local listOfTitles = ""
	for i, title in ipairs(TitlesAvailable) do
		listOfTitles = listOfTitles .. "\n[" .. i .."]: " .. title
	end
	local listOfColors = ""
	for i, color in ipairs(colorsAvailable) do
		listOfColors = listOfColors .. "\n[" .. i .."]: " .. color
	end
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Available titles are -\n" .. listOfTitles .. "\nAvailable colors are - \n" .. listOfColors .. "\nDo /title [NumberHere], [colorNumber] for the title you want to pick or /title remove to remove your title")
end

-- talkaction to set title

local talk = TalkAction("/title", "!title")

function talk.onSay(player, words, param)

	if param ~= "" then
        local split = param:split(",")
        if split[1] == "remove" then
            player:setStorageValue(PlayerStorageKeys.playerTitle, 0)
            PLAYERTITLES[player:getName()] = nil
            clearTitleForAllPlayers(player:getName())

        elseif TitlesAvailable[tonumber(split[1])] and colorsAvailable[tonumber(split[2])] then

            player:setStorageValue(PlayerStorageKeys.playerTitle, tonumber(split[1]))
            player:setStorageValue(PlayerStorageKeys.playerTitleColor, tonumber(split[2]))

            local playerName = player:getName()
            PLAYERTITLES[playerName] = {titleId = tonumber(split[1]), color = colorsAvailable[tonumber(split[2])]}
            sendNewTitleToAllPlayers(playerName, PLAYERTITLES[playerName].titleId, PLAYERTITLES[playerName].color)
        else
            sendTitleInfo(player)
        end
	else
		sendTitleInfo(player)
	end
	return false
end

talk:separator(" ")
talk:register()

-- opcode to recieve data if required

local opcodeEvent = CreatureEvent("playerTitlesOpCodeEvent")
opcodeEvent:type("extendedopcode")

function opcodeEvent.onExtendedOpcode(player, opcode, buffer)
    
    if(opcode == TITLES_OPCODE) then
        if(buffer == 'refresh') then
            for i, titleInfo in pairs(PLAYERTITLES) do
                local msg = {request = "update", name = i, title = titleInfo.titleId, color = titleInfo.color}
                player:sendExtendedOpcode(TITLES_OPCODE, json.encode(msg))
            end
        end
    end
    return true
end

opcodeEvent:register()