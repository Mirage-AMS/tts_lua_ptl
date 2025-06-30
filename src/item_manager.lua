require("src/container")
require("src/board")
require("src/zone")

function FactoryCreateItemManager()
    --[[
        item manager is a abstract class to manage actual item in the game
    ]]--
    local manager = {
        containers = {},
        boards = {},
        zones = {},
    }

    -- Getters
    function manager:getContainer(name)
        return self.containers[name]
    end

    function manager:getBoard(name)
        return self.boards[name]
    end

    function manager:getZone(name)
        return self.zones[name]
    end

    -- Save and Load
    function manager:onSave()
        local config = {
            { name = "containers", factory = FactoryCreateContainer },
            { name = "boards", factory = FactoryCreateBoard },
            { name = "zones", factory = FactoryCreateZone },
        }

        local savedData = {}

        for _, entry in ipairs(config) do
            local savedItems = {}
            local items = self[entry.name] or {}

            for k, v in pairs(items) do
                savedItems[k] = v:onSave()
            end

            savedData[entry.name] = savedItems
        end

        return savedData
    end

    function manager:onLoad(data)
        local config = {
            { name = "containers", factory = FactoryCreateContainer },
            { name = "boards", factory = FactoryCreateBoard },
            { name = "zones", factory = FactoryCreateZone },
        }

        for _, entry in ipairs(config) do
            local items = data[entry.name] or {}
            for k, v in pairs(items) do
                self[entry.name][k] = entry.factory():onLoad(v or {})
            end
        end

        return self
    end

    return manager
end