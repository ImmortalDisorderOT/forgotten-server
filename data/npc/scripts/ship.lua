local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local destinations = {}
local destinationsText = ""

NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this sailing-ship.'})

 -- Travel
local function addTravelKeyword(keyword, cost, destination)
    table.insert(destinations, keyword)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a ride to ' .. keyword:titleCase() .. ' for |TRAVELCOST|? Make sure to have your guiding starlight!', cost = cost})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', onlyFocus = true, reset = true})
end

addTravelKeyword('liberty bay', 100, Position(32313, 32824, 7))
addTravelKeyword('port hope', 100, Position(32595, 32741, 7))
addTravelKeyword('darashia', 100, Position(33211, 32456, 1))
addTravelKeyword('edron', 100, Position(33220, 31814, 8))
addTravelKeyword('yalahar', 100, Position(32785, 31276, 7))
addTravelKeyword('svargrond', 100, Position(32208, 31133, 7))
addTravelKeyword('ankrahmun', 100, Position(33194, 32857, 8))
addTravelKeyword('kazordoon', 100, Position(32659, 31957, 15))
addTravelKeyword('cormaya', 100, Position(33310, 31988, 15))
addTravelKeyword('farmine', 100, Position(33025, 31553, 10))
addTravelKeyword('zao', 100, Position(32993, 31551, 4))
addTravelKeyword('ab\'dendriel', 130, Position(32734, 31668, 6))
addTravelKeyword('oramond', 210, Position(33481, 31986, 7))
addTravelKeyword('roshamuul', 210, Position(33494, 32567, 7))
addTravelKeyword('gray island', 150, Position(33196, 31984, 7))
addTravelKeyword('thais', 130, Position(32310, 32210, 6))
addTravelKeyword('carlin', 80, Position(32387, 31820, 6))
addTravelKeyword('venore', 90, Position(32954, 32022, 6))
addTravelKeyword('oramond minos', 200, Position(33565, 31951, 13))


for _, destination in ipairs(destinations) do
   destinationsText =  destination:titleCase() .. ", " .. destinationsText
end

keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To ' .. destinationsText})
keywordHandler:addKeyword({'travel'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To ' .. destinationsText})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To ' .. destinationsText})


npcHandler:addModule(FocusModule:new())
