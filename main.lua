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
    --- upload data to server
    local function __uploadData()
        ---@TODO: WebRequest not implemented yet
        Wait.frames(
            function()
                print("Game onSnapshot")
                GAME:onSnapshot()
            end,
        1
        )
    end

    --- clear all discard zones
    local function __cleanupDiscards()
        for _, each_player_color in ipairs(DEFAULT_PLAYER_COLOR_LIST) do
            clearPlayerDiscardZone(each_player_color)
        end
    end

    -- state update
    local turnManager = GAME:getTurnManager()

    --------------------------------------------------------------------
    -- Quick Break
    --------------------------------------------------------------------
    if turnManager:isGameEnd() then
        broadcastToAll("游戏已经结束", DEFAULT_COLOR_WHITE)
        return
    end

    if not player then
        broadcastToAll("当前回合玩家为空, Turn被关闭或没有落座玩家", DEFAULT_COLOR_RED)
        return
    end

    --------------------------------------------------------------------
    -- Abnormal Turn Begginning
    --------------------------------------------------------------------

    local player_color = player.color
    if turnManager:getFirstPlayer() == nil and turnManager:getRound() == 0 then
        broadcastToAll("[热座模式]未经由开局按钮开始, 如非预期请联系开发者.", DEFAULT_COLOR_RED)
        turnManager:setFirstPlayer(player_color)
    end

    --------------------------------------------------------------------
    -- Normal Turn Begginning
    --------------------------------------------------------------------

    -- Current Player Update
    turnManager:setCurrentPlayer(player_color)

    if player_color == turnManager:getFirstPlayer() then
        -- Round Update
        turnManager:addRound()

        -- End Game Check (relied on turnManager.round)
        if turnManager:isGameEnd() then
            local playerService = GAME:getPlayerService()

            broadcastToAll("游戏结束", DEFAULT_COLOR_WHITE)
            local winners = turnManager:getWinners()
            for _, winner in ipairs(winners) do
                local playerInstance = playerService:getPlayerObject(winner)
                if playerInstance then
                    broadcastToAll(playerInstance.steam_name or winner .. " 胜利", winner)
                end
            end

            -- Cleanup Discards and Upload Data
            __cleanupDiscards()
            __uploadData()
            return
        end

        broadcastToAll("第" .. turnManager:getRound() .. "轮开始", DEFAULT_COLOR_WHITE)
    end

    -- Turn Update
    local TURN_STATE_BEGINNING_PHASE = 2
    turnManager:setState(TURN_STATE_BEGINNING_PHASE)
    updateButtonState()

    -- Cleanup Discards and Upload Data
    __cleanupDiscards()
    __uploadData()
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
