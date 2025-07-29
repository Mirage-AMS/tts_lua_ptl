require("mock/default")

---@class Container
---@field guid string?
---@field object Object?
---@field getPosition fun(self: Container): Vector
---@field putObject fun(self: Container, obj: Object)
---@field onSave fun(self: Container): table
---@field onLoad fun(self: Container, data: table): Container
---@return Container
function FactoryCreateContainer()
    ---@type Container
    ---@diagnostic disable-next-line: missing-fields
    local container = {
        guid = nil,
        object = nil,
    }

    -- Func Methods
    function container:getPosition()
        if not self.object then
            error("fatal error: container object is nil")
        end
        return self.object.getPosition()
    end

    function container:putObject(obj)
        if not self.object then
            error("fatal error: container object is nil")
        end
        self.object.putObject(obj)
    end

    -- Save and Load
    function container:onSave()
        return {
            guid = self.guid
        }
    end

    function container:onLoad(data)
        self.guid = data.guid
        self.object = getObjectFromGUID(data.guid)
        return self
    end

    return container
end