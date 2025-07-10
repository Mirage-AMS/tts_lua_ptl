require("com/enum_const")
require("src/game_mode_manager")

---@return ModeManager
function FactoryCreateModeManager()
    -- Mode Manager
    -- This module manages the game mode, which can be used to switch between different game modes
    ---@class ModeManager
    ---@field dev_mode number
    ---@field game_mode GameModeManager
    local mode_manager = {
        dev_mode = nil,
        game_mode = nil
    }

    -- game mode -------------------------------------------------------------------
    --- Get GameModeManager
    ---@return GameModeManager
    function mode_manager:getGameModeManager()
        if self.game_mode ~= nil then
            return self.game_mode
        end
        error("fatal error: game mode manager is nil")
    end

    -- dev mode -------------------------------------------------------------------
    --- Get if DevMode is Development
    ---@return boolean
    function mode_manager:isDevMode()
        return self.dev_mode == DevMode.Development
    end

    --- Set DevMode
    ---@param new_mode number
    ---@return nil
    function mode_manager:setDevMode(new_mode)
        if DevMode(new_mode) then
            self.dev_mode = new_mode
        end
        error("Invalid dev mode: " .. tostring(new_mode))
    end

    -- Save and Load ---------------------------------------------------------------

    --- Save the mode manager
    ---@return table
    function mode_manager:onSave()
        if self.game_mode ~= nil then
            return {
                dev_mode = self.dev_mode,
                game_mode = self.game_mode:onSave()
            }
        end
        error("fatal error: game mode is not set")
    end

    --- Load the mode manager
    ---@param data table
    ---@return ModeManager
    function mode_manager:onLoad(data)
        self.dev_mode = data.dev_mode or DevMode.Development
        self.game_mode = FactoryCreateGameModeManager():onLoad(data.game_mode)
        return self
    end

    return mode_manager
end