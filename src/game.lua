require("mock/default")
require("com/const")
require("com/const_game_board")
require("com/const_display_board")
require("com/const_main_board")
require("com/const_role_board")
require("com/enum_const")
require("com/basic")
require("com/json")
require("com/stopwatch")
require("src/public_service")
require("src/player_service")
require("src/build_data")
require("src/event_game_board")
require("src/event_dev_board")
require("src/event_display_board")
require("src/event_main_board")
require("src/event_context_menu")
require("src/event_vote_winner")
require("src/event_request")

local function clearScriptingZones()
    local objTbl = self.getObjects()
    for _, obj in ipairs(objTbl) do
        if isScripting(obj) then
            obj.destruct()
        end
    end
end

---@class Game
---@field version number
---@field public_service PublicService?
---@field player_service PlayerService?
---@field getPublicService fun(self: Game): PublicService
---@field getTurnManager fun(self: Game): TurnManager
---@field getPublicItemManager fun(self: Game): ItemManager
---@field getPlayerService fun(self: Game): PlayerService
---@field getPrivateItemManager fun(self:Game, player_color: string): ItemManager
---@field setAllBoardNotInteractable fun(self: Game)
---@field isPlayerLegendary fun(self: Game, player_color: string): boolean
---@field onLoad fun(self: Game, data: string): Game
---@field onSave fun(self: Game): string
---@field onSnapshot fun(self: Game): string
---@field init fun(self: Game): Game

---@return Game
function FactoryCreateGame()
    ---@type Game
    ---@diagnostic disable-next-line: missing-fields
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
        if not self.public_service then
            error("fatal error: public service not found")
        end
        return self.public_service
    end

    ---@return TurnManager
    function game:getTurnManager()
        return self:getPublicService():getTurnManager()
    end

    ---@return ItemManager
    function game:getPublicItemManager()
        return self:getPublicService():getItemManager()
    end

    ---@return PlayerService
    function game:getPlayerService()
        if not self.player_service then
            error("fatal error: player service not found")
        end
        return self.player_service
    end

    function game:getPrivateItemManager(player_color)
        return self:getPlayerService():getPlayer(player_color):getItemManager()
    end

    --- set all board interactable = false
    function game:setAllBoardNotInteractable()
        -- set all public board interactable = false
        local publicItemManager = self:getPublicItemManager()
        if not publicItemManager then
            error("fatal error: public item manager not found")
        end
        for _, v in pairs(publicItemManager.boards) do
            v:setInteractable(false)
        end
        for _, v in pairs(publicItemManager.displayBoards) do
            v:setInteractable(false)
        end

        -- set all player board interactable = false
        for _, player in ipairs(DEFAULT_PLAYER_COLOR_LIST) do
            local playerItemManager = self:getPrivateItemManager(player)
            if not playerItemManager then
                error("fatal error: public item manager not found")
            end
            for _, v in pairs(playerItemManager.boards) do
                v:setInteractable(false)
            end
        end
    end

    function game:isPlayerLegendary(player_color)
        -- 定义常量
        local LEGENDARY_POINT_LABEL = "●"
        local REQUIRED_POINTS = {
            [EnumGameGoal.QUICK] = 2,
            [EnumGameGoal.STANDARD] = 3
        }
        -- 输入检查
        local playerService = self:getPlayerService()
        if not playerService:isPlayerDefault(player_color) then
            return false
        end

        -- 检查传奇点数是否足够
        local isLegendaryPointEnough = false
        local gameGoal = self:getPublicService():getGameModeManager().game_goal
        if gameGoal == nil then
            error("fatal error: game goal not found")
        end

        local privateItemManager = self:getPrivateItemManager(player_color)
        local playerRoleBoard = privateItemManager:getBoard(NAME_BOARD_ROLE)
        if not playerRoleBoard then
            error("fatal error: player role board not found")
        end

        -- 计算传奇点数
        local legendaryPointCount = 0
        for _, buttonInfo in ipairs(playerRoleBoard:getButtons()) do
            if buttonInfo.label == LEGENDARY_POINT_LABEL then
                legendaryPointCount = legendaryPointCount + 1
            end
        end

        -- 检查点数是否满足当前游戏目标的要求
        local required = REQUIRED_POINTS[gameGoal]
        if required ~=nil and legendaryPointCount >= required then
            isLegendaryPointEnough = true
        end
        return isLegendaryPointEnough
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
            local loadedData = Json.decode(savedData)

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

        return self
    end

    --- OnSave Game
    ---@return string
    function game:onSave()
        local savedData = {
            version = self.version,
            public_service = self:getPublicService():onSave(),
            player_service = self:getPlayerService():onSave(),
        }
        return Json.encode(savedData)
    end

    --- OnSnapshot Game
    ---@return string
    function game:onSnapshot()
        local snapshotData = {
            version = self.version,
            public_service = self:getPublicService():onSnapshot(),
            player_service = self:getPlayerService():onSnapshot(),
        }
        return Json.encode(snapshotData)
    end

    --- Init game
    ---@return Game
    function game:init()
        -- init game board buttons
        local publicService = self:getPublicService()
        local gameBoard = publicService:getPublicBoard(NAME_BOARD_GAME)
        if gameBoard ~= nil then
            for _, param in ipairs(LIST_PARAM_GAME_BOARD_BUTTONS) do
                gameBoard:createButton(param)
            end
        else
            error("fatal error: game board not found")
        end

        -- init display board buttons && inputs
        local displayBoard = publicService:getItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)
        if displayBoard ~= nil then
            for _, param in ipairs(LIST_PARAM_DISPLAY_BOARD_BUTTONS) do
                displayBoard:createButton(param)
            end

            for _, param in ipairs(LIST_PARAM_DISPLAY_BOARD_INPUTS) do
                displayBoard:createInput(param)
            end

        else
            error("fatal error: display board not found")
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

        -- init player related buttons
        for _, player in ipairs(DEFAULT_PLAYER_COLOR_LIST) do
            local privateItemManager = self:getPrivateItemManager(player)

            -- init role board buttons (role board is now occupied, use hand zone board instead)
            local roleBoard = privateItemManager:getBoard(NAME_BOARD_ROLE_DISCARD)
            if roleBoard ~= nil then
                for _, param in ipairs(LIST_PARAM_ROLE_BOARD_BUTTONS) do
                    roleBoard:createButton(param)
                end
            else
                error("fatal error: role board not found")
            end
        end

        -- init development mode settings
        if publicService:isDevMode() then
            addContextMenuItem("Quit Dev-Mode", QuitDevMode, false)
        else
            Wait.frames(
                function()
                    --- check deck info
                    checkDeckInfo()
                    --- setup dev board hidden and  all boards not interactable
                    self:setAllBoardNotInteractable()
                    setDevBoardHidden()
                    --- update game mode and display board
                    updateGameMode({}, true)
                    updateDisplayBoard({}, true)
                end,
                1
            )
        end

        return self
    end

    return game
end