function onUse(player, item, fromPosition, target, toPosition, isHotkey)
  if player:isPzLocked() then
    player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cannot use a portal scroll while in battle")
    return false
  end
  local portalId = getFreePortalId()
  if portalId ~= nil then
    local portalPos = getClosePosition(player:getPosition())
    if portalPos then
      local cid = player:getId()
      local town = player:getTown()
      if player:getPosition():getDistance(town:getTemplePosition()) <= 60 then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You are too close to the city.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
      end
      if TOWN_PORTALS_PLAYERS[cid] then
        local tempPortal = TOWN_PORTALS_ACTIVE[TOWN_PORTALS_PLAYERS[cid].portalId]
        if tempPortal and tempPortal.creator == cid then
          removePortal(cid)
        end
      end
      TOWN_PORTALS_PLAYERS[cid] = {}
      TOWN_PORTALS_PLAYERS[cid].portalId = portalId
      
      local portalItemId = player:getStorageValue(PlayerStorageKeys.teleportType)
      if portalItemId == -1 then
        local portalItem = Game.createItem(1387, 1, portalPos)
      else 
        local portalItem = Game.createItem(player:getStorageValue(PlayerStorageKeys.teleportType), 1, portalPos)
      end
      portalItem:setActionId(5624)

      TOWN_PORTALS_ACTIVE[portalId] = {}
      TOWN_PORTALS_ACTIVE[portalId].item = portalItem
      TOWN_PORTALS_ACTIVE[portalId].creator = cid
      TOWN_PORTALS_ACTIVE[portalId].town = town
      TOWN_PORTALS_ACTIVE[portalId].pos = player:getPosition()
      if TOWN_PORTALS.duration ~= -1 then
        TOWN_PORTALS_ACTIVE[portalId].event = addEvent(removePortal, TOWN_PORTALS.duration * 1000, cid)
      end
      --player:removeItem(item:getId(), 1)
    else
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "No space to create portal. Please move somewhere else.")
      player:getPosition():sendMagicEffect(CONST_ME_POFF)
      return false
    end
  end
  return true
end

function getClosePosition(center)
  local position = nil
  local tile = nil

  for i = -1, 1 do
    position = Position(center.x + i, center.y, center.z)
    tile = Tile(position)
    if isFreeTile(tile) then return position end
  end

  for i = -1, 1 do
    position = Position(center.x, center.y + i, center.z)
    tile = Tile(position)
    if isFreeTile(tile) then return position end
  end

  return nil
end

function getFreePortalId()
  for i = 1, 255 do
    if not TOWN_PORTALS_ACTIVE[i] then
      return i
    end
  end
  return nil
end

function isFreeTile(tile)
	return not (tile == nil or tile:getGround() == nil or tile:hasProperty(TILESTATE_NONE) or tile:hasProperty(TILESTATE_FLOORCHANGE_EAST) or isItem(tile:getThing()) and not isMoveable(tile:getThing()) or tile:getTopCreature())
end