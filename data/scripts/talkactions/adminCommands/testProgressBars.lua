-- https://otland.net/threads/tfs-otclient-progressbar-for-creatures.263934/

local talk = TalkAction("/progressbar", "!progressbar")

function toboolean(str)
    local bool = false
    if str == "true" then
        bool = true
    end
    return bool
end


function talk.onSay(player, words, param)
    
	if not player:getGroup():getAccess()  then
		return true
	end
    local split = param:split(",")
    local duration = split[1]
    local ltr = split[2]
    -- get all creatures
    local creatures = Game.getSpectators(player:getPosition(), false, false, 9, 9, 8, 8)
    for __, creature in ipairs(creatures) do
        creature:sendProgressbar(duration, toboolean(ltr))
    end
	return false

end

talk:separator(" ")
talk:register()
