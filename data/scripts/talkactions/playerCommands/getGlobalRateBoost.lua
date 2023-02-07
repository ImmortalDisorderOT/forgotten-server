local talk = TalkAction("/boosts", "!boosts")

local function formatTime(time)
    if time >= 60 then
        local returnTime = math.floor(time / 60)
        local returnString = returnTime .. " minutes"
        return returnString
    else
        local returnString = time .. " seconds"
        return returnString
    end
end

function talk.onSay(player, words, param)
	local message = "Current boosts: "
	if getGlobalStorageValue(GlobalStorageKeys.expBoostedTime) > os.time() then
		message = message .. "\nExp " .. getGlobalStorageValue(GlobalStorageKeys.expBoostedRate) .. "% for " .. formatTime(getGlobalStorageValue(GlobalStorageKeys.expBoostedTime) - os.time())
	end
	
	if getGlobalStorageValue(GlobalStorageKeys.skillBoostedTime) > os.time() then
		message = message .. "\nSkill " .. getGlobalStorageValue(GlobalStorageKeys.skillBoostedRate) .. "% for " .. formatTime(getGlobalStorageValue(GlobalStorageKeys.skillBoostedTime) - os.time())
	end
		if getGlobalStorageValue(GlobalStorageKeys.orbBoostedTime) > os.time() then
		message = message .. "\nOrb Rate " .. getGlobalStorageValue(GlobalStorageKeys.orbBoostedRate) .. "% for " .. formatTime(getGlobalStorageValue(GlobalStorageKeys.orbBoostedTime) - os.time())
	end

	player:sendTextMessage(MESSAGE_INFO_DESCR, message) -- tell player
       
    return false
end

talk:separator(" ")
talk:register()
