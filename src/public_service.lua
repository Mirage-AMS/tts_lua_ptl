require("src/turn_manager")
require("src/item_manager")
require("src/mode_manager")

function FactoryCreatePublicService()
    local service = {
        turn_manager = {},
        item_manager = {},
        mode_manager = {},
    }

    -- get function
    function service:isDevelopmentMode()
        if self.mode_manager then
            return self.mode_manager:isDevelopmentMode()
        end
        error("fatal error: mode_manager is nil")
    end
    
    -- set function
    function service:setMode(new_mode)
        if self.mode_manager then
            self.mode_manager:setMode(new_mode)
        end
        error("fatal error: mode_manager is nil")
    end

    -- Save and Load
    function service:onSave()
        return {
            turn_manager = self.turn_manager:onSave(),
            item_manager = self.item_manager:onSave(),
            mode_manager = self.mode_manager:onSave(),
        }
    end

    function service:onLoad(data)
        self.turn_manager = FactoryCreateTurnManager():onLoad(data.turn_manager or {})
        self.item_manager = FactoryCreateItemManager():onLoad(data.item_manager or {})
        self.mode_manager = FactoryCreateModeManager():onLoad(data.mode_manager or {})
        return self
    end

    return service
end