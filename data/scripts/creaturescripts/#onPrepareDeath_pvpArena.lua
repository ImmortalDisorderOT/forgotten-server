local conditions = {
    CONDITION_POISON, CONDITION_FIRE,
    CONDITION_ENERGY, CONDITION_PARALYZE,
    CONDITION_DRUNK, CONDITION_DROWN,
    CONDITION_FREEZING, CONDITION_DAZZLED,
    CONDITION_BLEEDING, CONDITION_CURSED
}

local config = {
                    arenaTopLeftPos = Position(1260, 1096, 7),
                    arenaBottomRightPos = Position(1266, 1102, 7),
                    arenaExit = Position(1263, 1105, 7)
}

local creatureevent = CreatureEvent("Arena_Death")

function creatureevent.onPrepareDeath(creature, killer)
    if creature:isPlayer() and creature:getPosition():isInRange(config.arenaTopLeftPos, config.arenaBottomRightPos) then
        creature:addHealth(creature:getMaxHealth())
        creature:addMana(creature:getMaxMana())
        creature:teleportTo(config.arenaExit)
        creature:removeCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
        creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've been knocked out!")
        for _, condition in ipairs(conditions) do
            if creature:getCondition(condition) then
                creature:removeCondition(condition)
            end
        end
        if table.contains({SKULL_WHITE}, creature:getSkull()) then
            creature:setSkull(SKULL_NONE)
            creature:setSkullTime(0)
        end
    end
    return true
end

creatureevent:register()

local login = CreatureEvent("RegisterArenaDeath")

function login.onLogin(player)
    player:registerEvent("Arena_Death")
    return true
end

login:register()