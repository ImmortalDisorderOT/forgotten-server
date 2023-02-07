local talk = TalkAction("/dumpitems", "!dumpitems")

function talk.onSay(player, words, param)

	if not player:getGroup():getAccess()  then
		return true
	end
	local split = param:split(",")
		
	local startNum = split[1]
	local endNum = split[2]
	local lineLength = 15
	if endNum - startNum >= 10000 then
		lineLength = 30
	end
    local startpos = player:getPosition() -- dump start pos
    local pos = {x = startpos.x, y = startpos.y, z = startpos.z}
    local k = 0
    for i = startNum, endNum do -- items to move through, set a higher number if tibia 11+
        local it = ItemType(i)
        if it then
            if it:isMovable() and it:isPickupable() then -- item properties you search for
                k = k + 1
                Game.createTile(pos)
                Game.createItem(407, 1, pos)
                Game.createItem(i, 1, pos)
                pos.x = pos.x + 1
                if pos.x == startpos.x + lineLength then
                    pos.x = startpos.x
                    pos.y = pos.y + 1
                end
            end
        end
    end
    player:sendTextMessage(MESSAGE_INFO_DESCR, "dumped " .. k .. " items") -- tell player
end

talk:separator(" ")
talk:register()
