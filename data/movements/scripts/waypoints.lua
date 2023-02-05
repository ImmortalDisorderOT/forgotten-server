local WINDOW_ID = 4203
local BUTTON_ACCEPT = 0
local BUTTON_CLOSE = 1

local WAYPOINTS_STORAGE = 41875
local WAYPOINTS = {
  [1] = {
    name = "Disorder Island",
    position = Position(1164, 1116, 7)
  },
  [2] = {
    name = "Thais",
    position = Position(32369, 32243, 7)
  },
  [3] = {
    name = "Venore",
    position = Position(32957, 32074, 7)
  },
  [4] = {
    name = "Kazordoon",
    position = Position(32644, 31925, 11)
  },
  [5] = {
    name = "Carlin",
    position = Position(32360, 31776, 7)
  },
  [6] = {
    name = "Ab Dendriel",
    position = Position(32732, 31633, 7)
  },
  [7] = {
    name = "Liberty Bay",
    position = Position(32313, 32824, 7)
  },
  [8] = {
    name = "Port Hope",
    position = Position(32595, 32741, 7)
  },
  [9] = {
    name = "Ankrahmun",
    position = Position(33194, 32857, 8)
  },
  [10] = {
    name = "Darashia",
    position = Position(33211, 32456, 1)
  },
  [11] = {
    name = "Svargrond",
    position = Position(32208, 31133, 7)
  },
  [12] = {
    name = "Yalahar",
    position = Position(32785, 31276, 7)
  },
  [13] = {
    name = "Edron",
    position = Position(33220, 31814, 8)
  },
  [14] = {
    name = "Start Town",
    position = Position(1026, 882, 6)
  }
}

function onStepIn(player, item, position, fromPosition)
  if player:isPlayer() and fromPosition:getDistance(position) == 1 then
    
    for i = 1, #WAYPOINTS do
      local waypoint = WAYPOINTS[i]
      if position == waypoint.position and player:getStorageValue(WAYPOINTS_STORAGE + i) ~= 1 then
        player:setStorageValue(WAYPOINTS_STORAGE + i, 1)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "New waypoint unlocked!\n-- " .. waypoint.name .. " --")
        return true
      end
    end

    local empty = true
    for i = 1, #WAYPOINTS do
      local waypoint = WAYPOINTS[i]
      if position == waypoint.position and player:getStorageValue(WAYPOINTS_STORAGE + i) == 1 then
        empty = false
        break
      end
    end

    if not empty then
      player:registerEvent("WaypointsModal")
      
      local title = "Waypoints"
      local message = "Choose your destination."
      
      local window = ModalWindow(WINDOW_ID, title, message)

      window:addButton(BUTTON_ACCEPT, "Teleport")
      window:addButton(BUTTON_CLOSE, "Close")

      for i = 1, #WAYPOINTS do
        local waypoint = WAYPOINTS[i]
        if player:getStorageValue(WAYPOINTS_STORAGE + i) == 1 then
          window:addChoice(i, waypoint.name)
        end
      end

      window:setDefaultEnterButton(BUTTON_ACCEPT)
      window:setDefaultEscapeButton(BUTTON_CLOSE)

      window:sendToPlayer(player)
    end
  end
	return true
end

function onWaypointsModal(player, modalWindowId, buttonId, choiceId)  
  player:unregisterEvent("WaypointsModal")

  if modalWindowId == WINDOW_ID then
      if buttonId == BUTTON_ACCEPT then
        if player:getStorageValue(WAYPOINTS_STORAGE + choiceId) == 1 then
          player:teleportTo(WAYPOINTS[choiceId].position)
		  WAYPOINTS[choiceId].position:sendMagicEffect(CONST_ME_ENERGYAREA)
        end
      end
  end
end