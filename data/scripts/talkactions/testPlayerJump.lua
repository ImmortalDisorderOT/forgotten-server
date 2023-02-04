-- https://otland.net/threads/tfs-otclient-progressbar-for-creatures.263934/

local talk = TalkAction("/testjump", "!testjump")


function talk.onSay(player, words, param)

    local AreaX = 13 -- X range who will receive "jump packet" (all players in X range)
    local AreaY = 8 -- Y range who will receive "jump packet" (all players in Y range)

    -- getting Spectators around person who used jump
    local spectators = Game.getSpectators(player:getPosition(), false, true, AreaX, AreaX, AreaY, AreaY)
    if #spectators == 0 then
        return nil
    end

    -- Release of function // JumpCreature (self, creatureID, jumpHeight, jumpDuration, jumpStraight(true or false))
    for index, spectator in ipairs(spectators) do
        if spectator:getId() ~= player then
            playerID = player:getId()
            spectator:JumpCreature(playerID,100,1000,1)
        end
    end

    return false
end

talk:separator(" ")
talk:register()
