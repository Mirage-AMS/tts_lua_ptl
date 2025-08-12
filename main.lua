require("mock/default")
require("com/const")
require("src/game")

---@diagnostic disable-next-line:lowercase-global
function onLoad(saved_data)
    -- check saved data version and decide to use saved data or not
    GAME = FactoryCreateGame():onLoad(saved_data):init()
end

---@diagnostic disable-next-line:lowercase-global
function onSave()
    return GAME:onSave()
end

--[[
onPlayerTurn(player, previous_player)
-- [Player] player: Player whose turn is starting.
-- [Player ]previous_player: Player whose turn just finished, or nil if this is the first turn.
]]--
---@diagnostic disable-next-line:lowercase-global
function onPlayerTurn(player, _)
    -- state update
    local turnManager = GAME:getTurnManager()
    if not player then
        print("Turn disabled, Please check it")
        return
    end

    local player_color = player.color
    if turnManager:getFirstPlayer() == nil then
        broadcastToAll("[热座模式]未经由开局按钮开始, 如非预期请联系开发者.")
        turnManager:setFirstPlayer(player_color)
    end

    -- record current player
    turnManager:setCurrentPlayer(player_color)

    -- turn update
    turnManager:setState(2)
    updateButtonState()

    -- round update
    if player_color == turnManager:getFirstPlayer() then
        turnManager:addRound()
        broadcastToAll("第" .. turnManager:getRound() .. "轮开始", player_color)
    end

end

---@diagnostic disable-next-line:lowercase-global
function tryObjectEnterContainer(container, object)
    -- The below is the standard tag interaction rule:
    -- If the 'feature' does not have any tags, or if the
    -- feature and object share a tag.
    local allow_interaction = not container.hasAnyTag() or container.hasMatchingTag(object)
    return allow_interaction
end

---@diagnostic disable-next-line:lowercase-global
function onObjectLeaveContainer(container, object)
    -- leaving-object tags container's tag
    for _, tag in pairs(container.getTags()) do
        object.addTag(tag)
    end
end
