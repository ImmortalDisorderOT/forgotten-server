boostedMonsters = {}
boostedMonstersExperienceMultiplier = 2 -- 1 = default, 2 = 200% (aka, double experience)
boostedMonstersLootChanceMultiplier = 2 -- 1 = default, 2 = 200% (aka, double chance of loot.) (1.36% -> 2.72%)(88% -> 100%)

local boostedMonstersAmount = 2 -- how many arrays from boostedMonstersList will be chosen
-- NOTE: Ensure that this amount does not exceed the amount of arrays in boostedMonstersAmount.. or your server will crash.

local boostedMonstersList = {
    {"rat", "cave rat"}, -- setup like this, so an entire monster race can become boosted
    {"troll"},
    {"cyclops"}, -- don't put the same monster twice.. or bad things might happen.
    {"demon"},
    {"fire elemental"}
}

local function generateBoostedMonstersText()
    local text = ""
    for i = 1, #boostedMonsters do
        if text ~= "" then
            if i == #boostedMonsters then
                text = text .. " and "
            else
                text = text .. ", "
            end
        end
        text = text .. boostedMonsters[i]
    end
    text = "Today's boosted monsters are " .. text .. "."
    return text
end

local function chooseBoostedMonsters()
    local boostedMonstersCount = 0
    while boostedMonstersCount < boostedMonstersAmount do
        local randomMonster = math.random(#boostedMonstersList)
        if not table.contains(boostedMonsters, boostedMonstersList[randomMonster][1]:lower()) then
            for i = 1, #boostedMonstersList[randomMonster] do
                table.insert(boostedMonsters, boostedMonstersList[randomMonster][i]:lower())
            end
            boostedMonstersCount = boostedMonstersCount + 1
        end
    end
end

local function splitWithComma(inputstring)
    local array = {}
    for str in string.gmatch(inputstring, "[^,]+") do
        table.insert(array, str)
    end
    return array
end

local function writeBoostedMonstersToFile()
    local text = ""
    for i = 1, #boostedMonsters do
        if text ~= "" then
            text = text ..  ","
        end
        text = text .. boostedMonsters[i]
    end
    local file = io.open("data\\logs\\boostedMonsters.txt", "w+")
    file:write(text)
    file:close()
end

local function updateBoostedMonstersFromFile()
    local file = io.open("data\\logs\\boostedMonsters.txt", "r")
    local text = file:read()
    boostedMonsters = splitWithComma(text)
    file:close()
end

local onStartup_boostedMonsters = GlobalEvent("onStartup_boostedMonsters")

function onStartup_boostedMonsters.onStartup()
    local file = io.open("data\\logs\\boostedMonsters.txt", "r")
    if file ~= nil then
        file:close()
        updateBoostedMonstersFromFile()
    else
        chooseBoostedMonsters()
        writeBoostedMonstersToFile()
    end
    local text = generateBoostedMonstersText()
    addEvent(print, 0, text)
    return true
end

onStartup_boostedMonsters:register()


local onTime_boostedMonsters = GlobalEvent("onTime_boostedMonsters")

function onTime_boostedMonsters.onTime()
    boostedMonsters = {}
    chooseBoostedMonsters()
    writeBoostedMonstersToFile()
    local text = generateBoostedMonstersText()
    print(text)
    Game.broadcastMessage(text)
    return true
end

onTime_boostedMonsters:time("00:00:00")
onTime_boostedMonsters:register()


local loginEvent = CreatureEvent("onLogin_boostedMonsters")
loginEvent:type("login")

function loginEvent.onLogin(player)
    
end