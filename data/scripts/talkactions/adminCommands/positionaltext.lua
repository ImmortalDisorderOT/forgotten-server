local effects = {CONST_ME_NONE, CONST_ME_DRAWBLOOD, CONST_ME_LOSEENERGY, CONST_ME_POFF, CONST_ME_BLOCKHIT, CONST_ME_EXPLOSIONAREA, CONST_ME_EXPLOSIONHIT, CONST_ME_FIREAREA, CONST_ME_YELLOW_RINGS, CONST_ME_GREEN_RINGS, CONST_ME_HITAREA, CONST_ME_TELEPORT, CONST_ME_ENERGYHIT, CONST_ME_MAGIC_BLUE, CONST_ME_MAGIC_RED, CONST_ME_MAGIC_GREEN, CONST_ME_HITBYFIRE, CONST_ME_HITBYPOISON, CONST_ME_MORTAREA, CONST_ME_SOUND_GREEN, CONST_ME_SOUND_RED, CONST_ME_POISONAREA, CONST_ME_SOUND_YELLOW, CONST_ME_SOUND_PURPLE, CONST_ME_SOUND_BLUE, CONST_ME_SOUND_WHITE, CONST_ME_BUBBLES, CONST_ME_CRAPS, CONST_ME_GIFT_WRAPS, CONST_ME_FIREWORK_YELLOW, CONST_ME_FIREWORK_RED, CONST_ME_FIREWORK_BLUE, CONST_ME_STUN, CONST_ME_SLEEP, CONST_ME_WATERCREATURE, CONST_ME_GROUNDSHAKER, CONST_ME_HEARTS, CONST_ME_FIREATTACK, CONST_ME_ENERGYAREA, CONST_ME_SMALLCLOUDS, CONST_ME_HOLYDAMAGE, CONST_ME_BIGCLOUDS, CONST_ME_ICEAREA, CONST_ME_ICETORNADO, CONST_ME_ICEATTACK, CONST_ME_STONES, CONST_ME_SMALLPLANTS, CONST_ME_CARNIPHILA, CONST_ME_PURPLEENERGY, CONST_ME_YELLOWENERGY, CONST_ME_HOLYAREA, CONST_ME_BIGPLANTS, CONST_ME_CAKE, CONST_ME_GIANTICE, CONST_ME_WATERSPLASH, CONST_ME_PLANTATTACK, CONST_ME_TUTORIALARROW, CONST_ME_TUTORIALSQUARE, CONST_ME_MIRRORHORIZONTAL, CONST_ME_MIRRORVERTICAL, CONST_ME_SKULLHORIZONTAL, CONST_ME_SKULLVERTICAL, CONST_ME_ASSASSIN, CONST_ME_STEPSHORIZONTAL, CONST_ME_BLOODYSTEPS, CONST_ME_STEPSVERTICAL, CONST_ME_YALAHARIGHOST, CONST_ME_BATS, CONST_ME_SMOKE, CONST_ME_INSECTS, CONST_ME_DRAGONHEAD, CONST_ME_ORCSHAMAN, CONST_ME_ORCSHAMAN_FIRE, CONST_ME_THUNDER, CONST_ME_FERUMBRAS, CONST_ME_CONFETTI_HORIZONTAL, CONST_ME_CONFETTI_VERTICAL, CONST_ME_BLACKSMOKE, CONST_ME_REDSMOKE, CONST_ME_YELLOWSMOKE, CONST_ME_GREENSMOKE, CONST_ME_PURPLESMOKE, CONST_ME_EARLY_THUNDER, CONST_ME_RAGIAZ_BONECAPSULE, CONST_ME_CRITICAL_DAMAGE, CONST_ME_PLUNGING_FISH}
local positions = {} -- {positionData, text, effect}

local globalevent = GlobalEvent("positional_text")

function globalevent.onThink(interval)
    local player = Game.getPlayers()
    if #player < 1 then
        return true
    end
    for i = 1, #positions do
        if positions[i][2] ~= "no text" then
            player[1]:say(positions[i][2], TALKTYPE_MONSTER_SAY, false, nil, positions[i][1])
        end
        if positions[i][3] ~= CONST_ME_NONE then
            positions[i][1]:sendMagicEffect(positions[i][3])
        end
    end
    return true
end

globalevent:interval(3000)
globalevent:register()

-----------------------------------------------------------------------------

local talk = TalkAction("/positionaltext")

function talk.onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return false
    end

    local playerPosition = player:getPosition()

    local split = param:splitTrimmed(",")
    if not split[2] then
        split[2] = "CONST_ME_NONE"
    end

    local text = split[1]
    local effect = (tonumber(split[2]) ~= nil and tonumber(split[2]) or _G[split[2]]) -- converts the string into a number if possible otherwise the variable name or string into number

    if not isInArray(effects, effect) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Effect parameter (" .. split[2] .. ") is invalid. Check spelling, or use the number variant.")
        return false
    end

    for i = 1, #positions do
        if positions[i][1] == playerPosition then
            if param == "" then
                table.remove(positions, i)
                player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "This position will no longer have text or effects.")
                return false
            end
            positions[i][2] = text
            positions[i][3] = effect
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Text and effects for this position have been updated.")
            return false
        end
    end

    if param == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Requires param; /positionaltext text[, effect] -> /positionaltext no text, effect\nExample 1: /positionaltext text with no effect\nExample 2: /positionaltext teleport effect with text, CONST_ME_TELEPORT\nExample 3: /positionaltext no text, CONST_ME_TELEPORT")
        return false
    end

    table.insert(positions, {playerPosition, text, effect})
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Text and effects for this position has been activated.")
    return false
end

talk:separator(" ")
talk:register()