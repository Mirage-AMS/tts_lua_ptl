---@return Container
function FactoryCreateContainer()
    ---@class Container
    ---@field guid string?
    ---@field object Object?
    local container = {
        guid = nil,
        object = nil,
    }

    --------------------------------------------------------
    -- Func Methods
    --------------------------------------------------------
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