require("com/enum_const")

function FactoryCreateModeManager()
    -- Mode Manager
    -- This module manages the game mode, which can be used to switch between different game modes
    local mode_manager = {
        mode = GameMode.Development, -- Default mode is Development
    }

    function mode_manager:setMode(new_mode)
        if new_mode == GameMode.Development or new_mode == GameMode.Guest then
            self.mode = new_mode
        else
            error("Invalid game mode: " .. tostring(new_mode))
        end
    end

    function mode_manager:isDevelopmentMode()
        return self.mode == GameMode.Development
    end

    -- Save and Load
    function mode_manager:onSave()
        return { mode = self.mode }
    end

    function mode_manager:onLoad(data)
        self.mode = data.mode or GameMode.Development
        return self
    end

    return mode_manager
end