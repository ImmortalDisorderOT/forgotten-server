--portal types
possiblePortals = {1387, 36767, 39656, 39657, 25417, 1397, 36825, 35635, 32635, 32636, 35663}

function sendRandom(r)
    return math.random(-r, r)
end

function formatTime(time)
    if time >= 60000 then
        local returnTime = math.floor( (time / 1000) / 60)
        local returnString = returnTime .. " minutes"
        return returnString
    else
        local returnTime = time / 1000
        local returnString = returnTime .. " seconds"
        return returnString
    end
end

function getActiveMapUser(monsterDamageMap)
    for i, _ in pairs(monsterDamageMap) do
        if ACTIVEMAPS[i] then
            return i
        end
    end
    return nil
end


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function createTeleport(position, destination, playerId)

	local teleportId = 1387
    if playerId then
        local player = Player(playerId)
        local temp = player:getStorageValue(PlayerStorageKeys.teleportType)
		if table.contains(possiblePortals, temp) then
			teleportId = temp
		end
    end

    local teleportItem = Game.createItem(teleportId, 1, position)
    teleportItem:setDestination(destination)
end

function removeTeleport(position, playerId)

	local teleportId = 1387
    if playerId then
        local player = Player(playerId)
        local temp = player:getStorageValue(PlayerStorageKeys.teleportType)
		if table.contains(possiblePortals, temp) then
			teleportId = temp
		end
    end

    local teleportItem = Tile(position):getItemById(teleportId)
    if teleportItem then
        teleportItem:remove()
        position:sendMagicEffect(CONST_ME_POFF)
    end
end

function doGenerateMaze(fromPos, toPos, itemid, duration)
    local startPos, stack = Position(fromPos.x + 1, fromPos.y + 1, fromPos.z), {}
    local directions = {NORTH, SOUTH, EAST, WEST}
    duration = duration or -1
    function doMoveCell(currentPos)
        local cell_found = true
        while cell_found do
            stack[#stack + 1] = currentPos.x .. currentPos.y
            local cells = {}
            for i = 1, #directions do
                local cell_pos, wall_pos = Position(currentPos), Position(currentPos)
                cell_pos:getNextPosition(directions[i], 2)
                wall_pos:getNextPosition(directions[i], 1)
                if cell_pos:isInRange(fromPos, toPos) and not isInArray(stack, cell_pos.x .. cell_pos.y) then
                    cells[#cells + 1] = {cell = cell_pos, wall = wall_pos}
                end
            end
            if #cells > 0 then
                local random = math.random(#cells)
                local wall = Tile(cells[random].wall):getItemById(itemid)
                if wall then
                    wall:remove()
                    if duration > 0 then
                        addEvent(Game.createItem, duration, itemid, 1, cells[random].wall)
                    end
                end
                doMoveCell(cells[random].cell)
            else
                cell_found = false
            end
        end
    end
    doMoveCell(startPos)
end

function annouceEvent(msg)
    for _, targetPlayer in ipairs(Game.getPlayers()) do
		targetPlayer:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, msg)
	end
end