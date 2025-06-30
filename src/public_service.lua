require("src/turn_manager")
require("src/item_manager")

function FactoryCreatePublicService()
    local service = {
        turn_manager = {},
        item_manager = {},
    }

    -- Save and Load
    function service:onSave()
        return {
            turn_manager = self.turn_manager:onSave(),
            item_manager = self.item_manager:onSave(),
        }
    end

    function service:onLoad(data)
        self.turn_manager = FactoryCreateTurnManager():onLoad(data.turn_manager or {})
        self.item_manager = FactoryCreateItemManager():onLoad(data.item_manager or {})
        return self
    end

    return service
end