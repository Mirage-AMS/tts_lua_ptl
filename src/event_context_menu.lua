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

        local toRunFunc = function()
            -- set dev-board hidden
            setDevBoardHidden()
            -- setup role card
            setupRoleCard()
            -- setup game board
            updateGameMode({}, true)
            -- disable dev mode
            GAME:getPublicService():setDevMode(DevMode.GUEST)
            broadcastToAll("Dev-Mode Disabled")
            clearContextMenu()
        end

        Wait.time(toRunFunc,4)
    else
        broadcastToAll("Dev-Mode has been Disabled, do not use this in Game")
    end
end