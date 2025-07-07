require("mock/default")
require("com/const")
require("com/basic")
require("src/public_service")
require("src/player_service")
require("src/build_data")
require("src/event_dev_mode")

local function clearScriptingZones()
    local objTbl = self.getObjects()
    for _, obj in ipairs(objTbl) do
        if isScripting(obj) then
            obj.destruct()
        end
    end
end


function FactoryCreateGame()
    local game = {
        version = 0,
        public_service = {},
        player_service = {},
    }

    ---------------------------------------------------------------------
    --  Quick Access Members
    ---------------------------------------------------------------------
    function game:getTurnManager()
        return self.public_service.turn_manager
    end

    function game:getPublicItemManager()
        if self.public_service then
            return self.public_service.item_manager
        end
        error("fatal error: public_service not initialized")
    end

    function game:getPlayerService()
        return self.player_service
    end

    function game:getPrivateItemManager(player_color)
        return self:getPlayerService():getPlayer(player_color).item_manager
    end

    function game:isDevelopmentMode()
        return self.public_service:isDevelopmentMode()
    end

    ---------------------------------------------------------------------
    --  Save and Load
    ---------------------------------------------------------------------
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

        -- init main board buttons
        local itemManager = self:getPublicItemManager()
        local mainBoard = itemManager:getBoard(NAME_BOARD_MAIN)
        if mainBoard then
            for _, param in ipairs(LIST_PARAM_ONLOAD_BUTTONS) do
                mainBoard:createButton(param)
            end
        else
            print("error: main board not found")
        end
    end

    return game
end