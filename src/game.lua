require("mock/default")
require("com/const")
require("com/const_main_board")
require("com/basic")
require("src/public_service")
require("src/player_service")
require("src/build_data")
require("src/event_dev_board")
require("src/event_game_board")
require("src/event_main_board")

local function clearScriptingZones()
    local objTbl = self.getObjects()
    for _, obj in ipairs(objTbl) do
        if isScripting(obj) then
            obj.destruct()
        end
    end
end

---@return Game
function FactoryCreateGame()
    ---@class Game
    ---@field version number
    ---@field public_service PublicService
    ---@field player_service PlayerService
    local game = {
        version = 0,
        public_service = nil,
        player_service = nil,
    }

    ---------------------------------------------------------------------
    --  Quick Access Members
    ---------------------------------------------------------------------
    ---@return PublicService
    function game:getPublicService()
        return self.public_service
    end

    ---@return TurnManager
    function game:getTurnManager()
        return self:getPublicService().turn_manager
    end

    ---@return ItemManager
    function game:getPublicItemManager()
        return self:getPublicService().item_manager
    end

    ---@return PlayerService
    function game:getPlayerService()
        return self.player_service
    end

    function game:getPrivateItemManager(player_color)
        return self:getPlayerService():getPlayer(player_color).item_manager
    end

    ---------------------------------------------------------------------
    --  Save and Load
    ---------------------------------------------------------------------
    --- Onload Game
    ---@param savedData string
    ---@return Game
    function game:onLoad(savedData)
        -- 默认数据构建函数
        local data
        if savedData and savedData ~= "" then
            print("解析保存的数据")
            local loadedData = JSON.decode(savedData)

            -- 验证数据有效性和版本
            if loadedData and tonumber(loadedData.version) then
                local dataVersion = tonumber(loadedData.version)
                local currentVersion = tonumber(SCRIPT_VERSION)

                if dataVersion >= currentVersion then
                    print("使用保存的数据")
                    data = loadedData
                else
                    print("保存的数据版本过旧，使用默认数据")
                    data = buildDefaultData()
                    clearScriptingZones()
                end
            else
                print("保存的数据格式无效，使用默认数据")
                data = buildDefaultData()
                clearScriptingZones()
            end
        else
            print("没有保存的数据，使用默认数据")
            data = buildDefaultData()
            clearScriptingZones()
        end

        -- 初始化服务
        self.version = SCRIPT_VERSION
        self.public_service = FactoryCreatePublicService():onLoad(data.public_service or {})
        self.player_service = FactoryCreatePlayerService():onLoad(data.player_service or {})

        -- 初始化游戏
        self:init()

        return self
    end

    --- OnSave Game
    ---@return string
    function game:onSave()
        local savedData = {
            version = self.version,
            public_service = self.public_service:onSave(),
            player_service = self.player_service:onSave(),
        }
        return JSON.encode(savedData)
    end

    function game:init()
        -- init development mode settings
        addContextMenuItem("switch dev mode", SwitchDevMode, false)

        -- init game board buttons
        local publicService = self:getPublicService()
        local gameBoard = publicService:getPublicBoard(NAME_BOARD_GAME)
        if gameBoard ~= nil then
            -- TODO: init game board buttons
        else
            error("fatal error: game board not found")
        end

        -- init main board buttons
        local mainBoard = publicService:getPublicBoard(NAME_BOARD_MAIN)
        if mainBoard ~= nil then
            for _, param in ipairs(LIST_PARAM_ONLOAD_BUTTONS) do
                mainBoard:createButton(param)
            end
        else
            error("fatal error: main board not found")
        end
    end

    return game
end