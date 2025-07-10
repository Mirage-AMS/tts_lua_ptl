require("src/item_manager")

---@return PrivateService
function FactoryCreatePrivateService()
    ---@class PrivateService
    local service = {
        item_manager = {},
    }

    -- Save and Load
    ---@return table
    function service:onSave()
        return {
            item_manager = self.item_manager:onSave(),
        }
    end

    ---@param data table
    ---@return PrivateService
    function service:onLoad(data)
        self.item_manager = FactoryCreateItemManager():onLoad(data.item_manager or {})
        return self
    end

    return service
end