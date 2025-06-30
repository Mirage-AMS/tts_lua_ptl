require("src/item_manager")

function FactoryCreatePrivateService()
    local service = {
        item_manager = {},
    }

    -- Save and Load
    function service:onSave()
        return {
            item_manager = self.item_manager:onSave(),
        }
    end

    function service:onLoad(data)
        self.item_manager = FactoryCreateItemManager():onLoad(data.item_manager or {})
        return self
    end

    return service
end