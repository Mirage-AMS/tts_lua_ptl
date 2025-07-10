require("mock/default")
require("src/event_dev_board")
require("src/event_game_board")

--- QuitDevMode: for ContextMenu switching development mode on and off.
---@return nil
function QuitDevMode()
    if GAME:getPublicService():isDevMode() then
        broadcastToAll("Prepare to quit Dev-Mode")

        -- register deck info
        registerDeckInfo()

        Wait.time(
        function()
                GAME:getPublicService():setDevMode(DevMode.GUEST)
                broadcastToAll("Dev-Mode Disabled")
            end,
            3
        )
        return
    end
    broadcastToAll("Dev-Mode has been Disabled, do not use this in Game")
end

--- GuestSetup
---@return nil
function SetupGuestMode()
    if GAME:getPublicService():isDevMode() then
        broadcastToAll("Setup can only be run in Guest Mode")
    end

    -- setup role card
    setupRoleCard()

    -- setup game board
    updateGameMode({}, true)

end