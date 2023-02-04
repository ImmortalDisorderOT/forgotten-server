local OPCODE_LANGUAGE = 1

local OPCODE_TEST = 51
local OPCODE_PLAYERINFO = 52

local function getPlayerInfo(player)
    local text = "\nName: " .. player:getName()
    text = text .. "\nTime Online: " .. os.date('!%T', os.time() - player:getLastLoginSaved())
    
    local killCount = player:getSkullTime()
    text = text .. "\nFrags: " .. (killCount > 0 and math.ceil(killCount / configManager.getNumber(configKeys.FRAG_TIME)) or 0)
    
    local skull = player:getSkull()
    text = text .. "\nSkull: " .. (skull == 3 and "white" or skull == 4 and "red" or skull == 5 and "black" or "none")
    
    local pzLockTime = (player:isPzLocked() and player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT):getTicks() / 1000 or 0)
    text = text .. "\nPZ Lock: " .. (pzLockTime > 0 and os.date('!%T', pzLockTime) or "none")
    
    text = text .. "\nLevel: " .. player:getLevel()
    text = text .. "\nSex: " .. (player:getSex() == 0 and "female" or "male")
    text = text .. "\nVocation: " .. player:getVocation():getName()
    text = text .. "\nHealth: " .. player:getHealth() .. "/" .. player:getMaxHealth()
    text = text .. "\nMana: " .. player:getMana() .. "/" .. player:getMaxMana()
    text = text .. "\nSoul: " .. player:getSoul() .. "/" .. player:getMaxSoul()
    text = text .. "\nCapacity: " .. (player:getFreeCapacity() / 100) .. "/" .. (player:getCapacity() / 100)
    
    local feedTime = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
    text = text .. "\nFeed Time: " .. os.date('!%T', (feedTime and feedTime:getTicks() / 1000 or 0))
    
    text = text .. "\nMagic: " .. player:getMagicLevel()
    text = text .. "\nFist: " .. player:getSkillLevel(SKILL_FIST) .. ", with " .. (100 - player:getSkillPercent(SKILL_FIST)) .. "% to next level"
    text = text .. "\nClub: " .. player:getSkillLevel(SKILL_CLUB) .. ", with " .. (100 - player:getSkillPercent(SKILL_CLUB)) .. "% to next level"
    text = text .. "\nSword: " .. player:getSkillLevel(SKILL_SWORD) .. ", with " .. (100 - player:getSkillPercent(SKILL_SWORD)) .. "% to next level"
    text = text .. "\nAxe: " .. player:getSkillLevel(SKILL_AXE) .. ", with " .. (100 - player:getSkillPercent(SKILL_AXE)) .. "% to next level"
    text = text .. "\nDistance: " .. player:getSkillLevel(SKILL_DISTANCE) .. ", with " .. (100 - player:getSkillPercent(SKILL_DISTANCE)) .. "% to next level"
    text = text .. "\nShielding: " .. player:getSkillLevel(SKILL_SHIELD) .. ", with " .. (100 - player:getSkillPercent(SKILL_SHIELD)) .. "% to next level"
    text = text .. "\nFishing: " .. player:getSkillLevel(SKILL_FISHING) .. ", with " .. (100 - player:getSkillPercent(SKILL_FISHING)) .. "% to next level"
    return text
end

function onExtendedOpcode(player, opcode, buffer)
	print("recieved opcode " .. opcode)
    if opcode == OPCODE_LANGUAGE then
        -- otclient language
        if buffer == 'en' or buffer == 'pt' then
            -- example, setting player language, because otclient is multi-language...
            -- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
        end
    elseif opcode == OPCODE_TEST then
		print("recieved test")
        -- RECIEVE DATA TEST
        local status, json_data =
            pcall(
                function()
                    return json.decode(buffer)
                end
            )
        if not status then
            return false
        end
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "got data from client, also check console - pong response being sent")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, json_data.a)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, json_data.b)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, json_data.c.x)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, json_data.c.y)
        print(json_data.a)
        print(json_data.b)
        print(json_data.c.x)
        print(json_data.c.y)
        player:sendExtendedOpcode(OPCODE_TEST, "pong")

    elseif opcode == OPCODE_PLAYERINFO then
		print("recieved player info request")
        local response = getPlayerInfo(player)
        player:sendExtendedOpcode(OPCODE_PLAYERINFO, response)
    else
        -- other opcodes can be ignored, and the server will just work fine...
    end
end
