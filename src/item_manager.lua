require("src/container")
require("src/board")
require("src/board_display")
require("src/zone")

--- ItemManager is a class to manage certian types of items in the game.
---@class ItemManager
---@field containers table<string, Container>
---@field boards table<string, Board>
---@field displayBoards table<string, BoardDisplay>
---@field zones table<string, Zone>
---@field getContainer fun(self: ItemManager, name: string): Container?
---@field getBoard fun(self: ItemManager, name: string): Board?
---@field getBoardDisplay fun(self: ItemManager, name: string): BoardDisplay?
---@field getZone fun(self: ItemManager, name: string): Zone?
---@field onSave fun(self: ItemManager): table
---@field onSnapshot fun(self: ItemManager): table
---@field onLoad fun(self: ItemManager, data: table): ItemManager

---@return ItemManager
function FactoryCreateItemManager()
    local config = {
        { name = "containers", factory = FactoryCreateContainer },
        { name = "boards", factory = FactoryCreateBoard },
        { name = "displayBoards", factory = FactoryCreateBoardDisplay },
        { name = "zones", factory = FactoryCreateZone },
    }

    local snapConfig = {
        { name = "zones"}
    }

    ---@type ItemManager
    local manager = {
        -- 显式初始化所有存储表
        containers = {},
        boards = {},
        displayBoards = {},
        zones = {},

        getContainer = function(self, name)
            return self.containers[name]
        end,

        getBoard = function(self, name)
            return self.boards[name]
        end,

        getBoardDisplay = function(self, name)
            return self.displayBoards[name]
        end,

        getZone = function(self, name)
            return self.zones[name]
        end,

        onSave = function(self)
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
        end,

        onSnapshot = function(self)
            local snapshotData = {}

            for _, entry in ipairs(snapConfig) do
                local savedItems = {}
                local items = self[entry.name] or {}

                for k, v in pairs(items) do
                    savedItems[k] = v:onSnapshot()
                end

                snapshotData[entry.name] = savedItems
            end

            return snapshotData
        end,

        onLoad = function(self, data)
            for _, entry in ipairs(config) do
                local items = data[entry.name] or {}
                for k, v in pairs(items) do
                    self[entry.name][k] = entry.factory():onLoad(v or {})
                end
            end

            return self
        end
    }

    return manager
end