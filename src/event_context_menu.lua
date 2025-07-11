require("mock/default")
require("src/event_dev_board")
require("src/event_game_board")

local function setAllBoardNotInteractable()
    -- set all public board interactable = false
    local publicItemManager = GAME:getPublicItemManager()
    if not publicItemManager then
        error("fatal error: public item manager not found")
    end
    for _, v in pairs(publicItemManager.boards) do
        v:setInteractable(false)
    end

    -- set all player board interactable = false
    for _, player in ipairs(DEFAULT_PLAYER_COLOR_LIST) do
        local playerItemManager = GAME:getPrivateItemManager(player)
        if not playerItemManager then
            error("fatal error: public item manager not found")
        end
        for _, v in pairs(playerItemManager.boards) do
            v:setInteractable(false)
        end
    end
end


--- QuitDevMode: for ContextMenu switching development mode on and off.
---@return nil
function QuitDevMode()
    if GAME:getPublicService():isDevMode() then
        broadcastToAll("Prepare to quit Dev-Mode")
        -- set all board not interactable
        setAllBoardNotInteractable()

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