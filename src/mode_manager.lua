require("com/enum_const")
require("src/game_mode_manager")

---@class ModeManager
---@field dev_mode number?
---@field game_mode GameModeManager?
---@field getGameModeManager fun(self: ModeManager): GameModeManager
---@field isDevMode fun(self: ModeManager): boolean
---@field setDevMode fun(self: ModeManager, new_mode: number): ModeManager
---@field onSave fun(self: ModeManager): table
---@field onSnapshot fun(self: ModeManager): table
---@field onLoad fun(self: ModeManager, data: table): ModeManager

---@return ModeManager
function FactoryCreateModeManager()
    -- Mode Manager
    -- This module manages the game mode, which can be used to switch between different game modes
    ---@type ModeManager
    ---@diagnostic disable-next-line: missing-fields
    local mode_manager = {
        dev_mode = DevMode.DEV,
        game_mode = nil,
    }

    -- game mode -------------------------------------------------------------------
    --- Get GameModeManager
    ---@return GameModeManager
    function mode_manager:getGameModeManager()
        if not self.game_mode then
            error("fatal error: game mode manager is nil")
        end
        return self.game_mode
    end

    -- dev mode -------------------------------------------------------------------
    --- Get if DevMode is DEV
    ---@return boolean
    function mode_manager:isDevMode()
        return self.dev_mode == DevMode.DEV
    end

    --- Set DevMode
    ---@param new_mode number
    ---@return ModeManager
    function mode_manager:setDevMode(new_mode)
        if DevMode(new_mode) then
            self.dev_mode = new_mode
        else
            warn("Skip setting invalid dev-mode: " .. tostring(new_mode))
        end
        return self
    end

    -- Save and Load ---------------------------------------------------------------

    --- Save the mode manager
    ---@return table
    function mode_manager:onSave()
        return {
            dev_mode = self.dev_mode,
            game_mode = self:getGameModeManager():onSave()
        }
    end

    --- Snapshot the mode manager
    ---@return table
    function mode_manager:onSnapshot()
        return {
            dev_mode = self.dev_mode,
            game_mode = self:getGameModeManager():onSnapshot()
        }
    end

    --- Load the mode manager
    ---@param data table
    ---@return ModeManager
    function mode_manager:onLoad(data)
        if not data then return self end
        self.game_mode = FactoryCreateGameModeManager():onLoad(data.game_mode)
        return self:setDevMode(data.dev_mode)
    end

    return mode_manager
end