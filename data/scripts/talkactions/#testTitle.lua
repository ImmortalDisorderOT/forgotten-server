
local talk = TalkAction("/testtitle", "!testtitle")

function talk.onSay(player, words, param)

    local creatures = Game.getSpectators(player:getPosition(), false, false, 9, 9, 8, 8)
    for __, creature in ipairs(creatures) do
        local creatureOutfit = creature:getOutfit()
        creatureOutfit.lookTitle = tonumber(param)
        creature:setOutfit(creatureOutfit)
    end
	return false
end

talk:separator(" ")
talk:register()

