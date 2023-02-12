
function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local lookWings = tonumber(param)
	if lookWings >= 0 and lookWings < 1700 then
		local playerOutfit = player:getOutfit()
		playerOutfit.lookWings = lookWings
		player:setOutfit(playerOutfit)
	else
		player:sendCancelMessage("A look type with that id does not exist.")
	end
	return false
end
