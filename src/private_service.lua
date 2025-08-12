require("src/item_manager")


---@class PrivateService
---@field item_manager ItemManager?
---@field getItemManager fun(self: PrivateService): ItemManager
---@field onSave fun(self: PrivateService): table
---@field onLoad fun(self: PrivateService, data: table): PrivateService

---@return PrivateService
function FactoryCreatePrivateService()
    ---@type PrivateService
    ---@diagnostic disable-next-line: missing-fields
    local service = {
        item_manager = nil,
    }

    function service:getItemManager()
        if not self.item_manager then
            error("fatal error: item_manager is nil")
        end
        return self.item_manager
    end

    -- Save and Load
    ---@return table
    function service:onSave()
        return {
            item_manager = self:getItemManager():onSave(),
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