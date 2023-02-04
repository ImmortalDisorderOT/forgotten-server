-- Credits
-- Apollos for their maze generation code! Find it in https://otland.net/threads/tfs-1-3-generate-maze-function.263662/ in order to use code

-- the script will not re-generate the maze if a player relogs while in the maze... to protect them, suggest the maze be a no-logout zone

local config = {
    actionid = 65200, -- action id for the tile when the player steps in
    fromPos = Position(1304, 1111, 7), -- top left corner
	toPos = Position(1330, 1135, 7), -- bottom right corner
    itemid = 10747, -- itemID of the maze
	duration = 7000 -- how long is one maze iteration
}

local mazeToggled = false

local playersInMaze = {}

local function waitForMaze()

	for i=1, #playersInMaze do

		local playerId = table.remove(playersInMaze)
		local player = Player(playerId)

		if player:getPosition():isInRange(config.fromPos, config.toPos) then -- if there's atleast 1 person in the maze, keep going
			table.insert(playersInMaze, playerId)
			break
		end
	end

	if #playersInMaze >= 1 then
		doGenerateMaze(config.fromPos, config.toPos, config.itemid, config.duration)
		addEvent(waitForMaze, config.duration)
	else
		mazeToggled = false
	end
end

local moveEvent = MoveEvent()
moveEvent:type("stepin")

function moveEvent.onStepIn(player, item, position, fromPosition)
    if not player:isPlayer() then
        return true
    end
	
	if item:getActionId() == config.actionid then -- we are on the right tile
		table.insert(playersInMaze, player:getId())
		if not mazeToggled then
			doGenerateMaze(config.fromPos, config.toPos, config.itemid, config.duration) -- generate maze
			mazeToggled = true -- maze is active
			addEvent(waitForMaze, config.duration)
		end
	end

	return true
end

moveEvent:aid(config.actionid)
moveEvent:register()
