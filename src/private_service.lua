require("src/item_manager")

---@return PrivateService
function FactoryCreatePrivateService()
    ---@class PrivateService
    ---@field item_manager ItemManager?
    local service = {
        item_manager = nil,
    }

    -- Save and Load
    ---@return table
    function service:onSave()
        if not self.item_manager then
            error("fatal error: item_manager is nil")
        end
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