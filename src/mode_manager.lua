require("com/enum_const")

function FactoryCreateModeManager()
    -- Mode Manager
    -- This module manages the game mode, which can be used to switch between different game modes
    local mode_manager = {
        dev_mode = DevMode.Development, -- Default mode is Development
    }

    --- Get if DevMode is Development
    ---@return boolean
    function mode_manager:isDevMode()
        return self.dev_mode == DevMode.Development
    end

    --- Set DevMode
    ---@param new_mode number
    ---@return nil
    function mode_manager:setDevMode(new_mode)
        if new_mode == DevMode.Development or new_mode == DevMode.Guest then
            self.dev_mode = new_mode
        else
            error("Invalid dev mode: " .. tostring(new_mode))
        end
    end

    -- Save and Load
    function mode_manager:onSave()
        return { dev_mode = self.dev_mode }
    end

    function mode_manager:onLoad(data)
        self.dev_mode = data.dev_mode or DevMode.Development
        return self
    end

    return mode_manager
end