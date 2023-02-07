-- announce events
local announceLogin = CreatureEvent("announceLogin")

function announceLogin.onLogin(player)
    local msg = player:getName() .. " has logged in."
    annouceEvent(msg)
	return true
end

announceLogin:register()

local announceLogout = CreatureEvent("announceLogout")

function announceLogout.onLogout(player)
    local msg = player:getName() .. " has logged out."
    annouceEvent(msg)
	return true
end

announceLogout:register()

local announceDeath = CreatureEvent("announceDeath")

function announceDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if creature:isPlayer() then
        local msg = creature:getName() .. " has been killed by " .. killer:getName() .. "!"
        annouceEvent(msg)
    end

	return true
end

announceDeath:register()


local annouceLevel = CreatureEvent("annouceLevel")

function annouceLevel.onAdvance(player, skill, oldLevel, newLevel)
    if newLevel % 10 == 0 then
        local msg
        if skill < SKILL_MAGLEVEL then
            msg = player:getName() .. " has reached " .. getSkillName(skill) .. " level " .. newLevel .. "!"
        else
            msg = player:getName() .. " has reached " .. getSkillName(skill) .. " " .. newLevel .. "!"
        end
        annouceEvent(msg)
    end
    if newLevel - oldLevel > 10 then
        local msg
        if skill < SKILL_MAGLEVEL then
            msg = player:getName() .. " has reached " .. getSkillName(skill) .. " level " .. newLevel .. ", jumping from level " .. oldLevel ..  "!"
        else
            msg = player:getName() .. " has reached " .. getSkillName(skill) .. " " .. newLevel .. ", jumping from level " .. oldLevel ..  "!"
        end
        annouceEvent(msg)
    end
	return true
end

annouceLevel:register()