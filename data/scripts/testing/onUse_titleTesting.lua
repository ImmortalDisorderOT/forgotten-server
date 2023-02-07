local config = {
    [45015] = {"add"},
    [45016] = {"remove"},
}

local titleTestAction = Action()

function titleTestAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local index = config[item.actionid]
    -- add
    if index[1] == "add" then
        print("Adding titleId 2 (Test Title)")
        player:addTitle(2)
    -- remove
    elseif index[1] == "remove"  then
        print("Removing titleId 2 (Test Title)")
        player:removeTitle(2)
    end
    return true
end

for k, v in pairs(config) do
    titleTestAction:aid(k)
end
titleTestAction:register()