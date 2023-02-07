local tileRequirements = MoveEvent()

function tileRequirements.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end
  

   local tileRequirement = item.actionid
   local tileReq = tileRequirementsConfig[tileRequirement]

 
   -----------------------------------------------------------------------------------
   -- Check if player need storage --
   -----------------------------------------------------------------------------------
 
   if  tileReq.storageReq > 1 and player:getStorageValue(tileReq.storageReq) < 1 then
       player:teleportTo(fromPosition)
       player:getPosition():sendMagicEffect(CONST_ME_POFF)
       player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need "..tileReq.storageName.." to join "..tileReq.zoneName..".")
       return true
   end   

   -----------------------------------------------------------------------------------
   -- Check if player Max Level --
   -----------------------------------------------------------------------------------
    if  tileReq.maxLevel > 1 and player:getLevel() > tileReq.maxLevel then 
        player:teleportTo(fromPosition)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only players below of level "..tileReq.maxLevel.." to join "..tileReq.zoneName..".")
       return true
   end   
  
   -----------------------------------------------------------------------------------
   -- Check if player Min Level --
   ----------------------------------------------------------------------------------- 
    if  player:getLevel() < tileReq.minLevel then 
        player:teleportTo(fromPosition)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need level "..tileReq.minLevel.." to join "..tileReq.zoneName..".")
       return true
   end   
   -----------------------------------------------------------------------------------
   -- Check if player Teleport --
   ----------------------------------------------------------------------------------- 
    if  tileReq.teleport.x > 0 then
        player:teleportTo(tileReq.teleport)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    end

player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to "..tileReq.zoneName..".")
        return true
end



tileRequirements:type("stepin")
for i = 36000, 36100 do
tileRequirements:aid(i)
end
tileRequirements:register()