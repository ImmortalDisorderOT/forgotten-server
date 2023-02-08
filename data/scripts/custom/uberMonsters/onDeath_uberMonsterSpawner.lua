
local config = {
    warningTicks = 3, -- ticks, time is (timeBetweenOrbs * 1000) seconds, reduce to a lower number if orbs are being auto looted
    timeBetweenWarnings = 1000 -- time in milliseconds
}

local ignoredMobs = {"training monk"} -- list of mobs to ignore


-- not local because we want to call this in other scripts ( like orb loot, or on exp gain )
uberMonsterTiers = {
    [SKULL_WHITE] = { -- indexed for easy access, should be same as the skull it gives
        chance = 10000, -- chance is out of 100000
        skull = SKULL_WHITE, -- skull the mob has 
        effect = CONST_ME_MORTAREA, -- effect that happens when spawning the mob
        lootBoost = 0.25,
        orbChanceMultiplier = 1, -- chance for extra orb
        possibleExtraOrbs = 1, -- have 1 extra orbs ontop of the config.maxOrbs
        healthMultiplier = 1.5, -- health multipler
        experienceMultipler = 1.5, -- exp multipler
        damageMultipler = 1.1 -- damage multiplier
    },
    [SKULL_GREEN] = {
        chance = 5000, -- chance is out of 100000
        skull = SKULL_GREEN, -- skull the mob has SKULL_RED
        effect = CONST_ME_MORTAREA, -- effect that happens when spawning the mob
        lootBoost = 0.5,
        orbChanceMultiplier = 1,
        possibleExtraOrbs = 2,
        healthMultiplier = 2.5, -- health multipler
        experienceMultipler = 2.5, -- exp multipler
        damageMultipler = 1.5 -- damage multiplier
    },
    [SKULL_RED] = {
        chance = 1000, -- chance is out of 100000
        skull = SKULL_RED, -- skull the mob has SKULL_GREEN
        effect = CONST_ME_MORTAREA, -- effect that happens when spawning the mob
        lootBoost = 0.75,
        orbChanceMultiplier = 1,
        possibleExtraOrbs = 3,
        healthMultiplier = 5, -- health multipler
        experienceMultipler = 5, -- exp multipler
        damageMultipler = 3 -- damage multiplier
    },
    [SKULL_BLACK] = {
        chance = 100, -- chance is out of 100000
        skull = SKULL_BLACK, -- skull the mob has SKULL_WHITE
        effect = CONST_ME_MORTAREA, -- effect that happens when spawning the mob
        lootBoost = 1,
        orbChanceMultiplier = 2,
        possibleExtraOrbs = 4,
        healthMultiplier = 10, -- health multipler
        experienceMultipler = 10, -- exp multipler
        damageMultipler = 5 -- damage multiplier
    }
}


local function spawnMonster(name, tier, position)

    local monster = Game.createMonster(name, position, false, true) -- spawns monster
    if not monster then
        -- Something went wrong?
    end

    monster:setSkull(uberMonsterTiers[tier].skull) -- sets skull based on tier
    monster:setMaxHealth(monster:getMaxHealth() * uberMonsterTiers[tier].healthMultiplier) -- increases health based on the tier
    monster:setHealth(monster:getMaxHealth()) -- sets health to max
end

local function uberMonsterWarning(name, tier, position, tick)
    tick = tick or 1

    if tick > config.warningTicks then -- if we hit enough ticks spawn mob
        spawnMonster(name, tier, position)
        return true
    end

    position:sendMagicEffect(uberMonsterTiers[tier].effect) -- send magic effect for spawning

    -- resend event
    addEvent(uberMonsterWarning, config.timeBetweenWarnings, name, tier, position, (tick + 1))
end

local creatureevent = CreatureEvent("uberSpawner")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)

    if creature:isPlayer() or creature:getMaster() then 
        return true 
    end

    if creature:getSkull() > SKULL_NONE then -- if it's an uber... don't spawn another
        return true
    end
    local mobName = creature:getName():lower()

    if ignoredMobs[mobName] then
        return true -- ignore the mob from becoming an uber
    end

    
    local roll = math.random(100000)
    local position = creature:getPosition()
    if uberMonsterTiers[SKULL_BLACK].chance >= roll then uberMonsterWarning(mobName, SKULL_BLACK, position)
    elseif uberMonsterTiers[SKULL_RED].chance >= roll then uberMonsterWarning(mobName, SKULL_RED, position)
    elseif uberMonsterTiers[SKULL_GREEN].chance >= roll then uberMonsterWarning(mobName, SKULL_GREEN, position)
    elseif uberMonsterTiers[SKULL_WHITE].chance >= roll then uberMonsterWarning(mobName, SKULL_WHITE, position)
    end



    return true
end

creatureevent:register()

local creatureevent2 = CreatureEvent("uberMobDamage")
function creatureevent2.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)

    if not attacker then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if attacker:isPlayer() then -- if player do nothing
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local skull = attacker:getSkull() -- getting skull from mob
    -- dont increase damage from healing or mana drain, we already increased health, no need to do more healing
    if skull > SKULL_NONE and not (primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING or primaryType == COMBAT_MANADRAIN or secondaryType == COMBAT_MANADRAIN) then 
        return primaryDamage * uberMonsterTiers[skull].damageMultipler, primaryType, secondaryDamage * uberMonsterTiers[skull].damageMultipler, secondaryType
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType 
end

creatureevent2:register()

local login = CreatureEvent("RegisterUberMobDamage")

function login.onLogin(player)
    player:registerEvent("uberMobDamage") -- increase damage of the mob
    return true
end

login:register()
