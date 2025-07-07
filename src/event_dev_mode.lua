require("com/enum_const")

--- initDevelopmentMode: Initializes the game in development mode.
--- @return nil
local function initDevelopmentMode()
    -- TODO implement development mode initialization
    broadcastToAll("Development Mode Enabled")
    GAME.public_service:setMode(GameMode.Development)
end


--- cleanDevelopmentMode: Cleans up the game when switching out of development mode.
--- @return nil
local function cleanDevelopmentMode()
    -- TODO implement development mode cleanup
    broadcastToAll("Development Mode Disabled")
    GAME.public_service:setMode(GameMode.Guest)
end

--- SwitchDevMode: for ContextMenu switching development mode on and off.
---@return nil
function SwitchDevMode()
    if GAME:isDevelopmentMode() then
        initDevelopmentMode()
    else
        cleanDevelopmentMode()
    end
end
