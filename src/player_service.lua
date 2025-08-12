require("src/private_service")

---@class PlayerService
---@field players table<string, PrivateService>
---@field isPlayerDefault fun(self: PlayerService, player_color: string): boolean
---@field getPlayer fun(self: PlayerService, player_color: string): PrivateService
---@field getPlayerObjectList fun(self: PlayerService): PlayerInstance[]
---@field getPlayerObject fun(self: PlayerService, player_color: string): PlayerInstance?
---@field getSeatedPlayerColorList fun(self: PlayerService): string[]
---@field getSeatedPlayerNum fun(self: PlayerService): number
---@field letPlayerPingTable fun(self: PlayerService, player_color: string, position: Vector)
---@field onSave fun(self: PlayerService): table
---@field onSnapshot fun(self: PlayerService): table
---@field onLoad fun(self: PlayerService, data: table): PlayerService

---@return PlayerService
function FactoryCreatePlayerService()
    ---@type PlayerService
    ---@diagnostic disable-next-line: missing-fields
    local service = {
        players = {}
    }
    function service:isPlayerDefault(player_color)
        return isValInValList(player_color, DEFAULT_PLAYER_COLOR_LIST)
    end

    ---@return PrivateService
    function service:getPlayer(player_color)
        if player_color ~= nil and self.players[player_color] then
            return self.players[player_color]
        end
        error("Player not found for color: " .. tostring(player_color))
    end

    ---@return PlayerInstance[]
    function service:getPlayerObjectList()
        return Player.getPlayers()
    end

    ---@param player_color string
    ---@return PlayerInstance?
    function service:getPlayerObject(player_color)
        local playerTbl = self:getPlayerObjectList()
        for _, player in ipairs(playerTbl) do
            if player.color == player_color then
                return player
            end
        end
        return nil
    end

    ---@return string[]
    function service:getSeatedPlayerColorList()
        return getSeatedPlayers()
    end

    function service:getSeatedPlayerNum()
        return #self:getSeatedPlayerColorList()
    end

    --- Let a player ping the table.
    ---@param player_color string
    ---@param position Vector
    function service:letPlayerPingTable(player_color, position)
        if not position then
            error("Position is required")
        end

        local player = self:getPlayerObject(player_color)
        if not player then
            error("Player not found for color: " .. tostring(player_color))
        end
        player.pingTable(position)
    end

    -- Save and Load
    ---@return table
    function service:onSave()
        local data = {
            players = {}
        }
        for k, v in pairs(self.players) do
            data.players[k] = v:onSave() or {}
        end
        return data
    end

    function service:onSnapshot()
        local data = { players = {} }

        local function __snapshotPlayerHand(playerInstance)
            local snapshotData = {}
            for _, handObj in ipairs(playerInstance.getHandObjects()) do
                ---@cast handObj Object
                table.insert(snapshotData, getCardData(handObj))
            end

            return snapshotData
        end

        for playerColor, playerPrivateService in pairs(self.players) do
            local playerData = playerPrivateService:onSnapshot() or {}
            data.players[playerColor] = playerData

            local itemManagerData = playerData.item_manager or {}
            itemManagerData.zones = itemManagerData.zones or {}
            playerData.item_manager = itemManagerData

            local playerInstance = self:getPlayerObject(playerColor)
            if not playerInstance then
                error("Player instance not found for color: " .. tostring(playerColor))
            end
            itemManagerData.zones["Hand"] = __snapshotPlayerHand(playerInstance)
        end


        return data
    end

    ---@param data table
    ---@return PlayerService
    function service:onLoad(data)
        local playerData = data.players or {}
        for playerColor, eachPlayerData in pairs(playerData) do
            -- init safePlayerData to avoid nil values
            local safePlayerData = eachPlayerData or {}
            safePlayerData.player_color = playerColor

            -- 检查工厂函数返回值，避免nil赋值
            local playerPrivateService = FactoryCreatePrivateService()
            if not playerPrivateService then
                error(("Failed to create private service for player: %s"):format(tostring(playerColor)))
            end

            -- 记录加载结果，确保onLoad返回有效实例
            local loadedService = playerPrivateService:onLoad(safePlayerData)
            if not loadedService then
                error(("Failed to load data for player: %s"):format(tostring(playerColor)))
            end

            self.players[playerColor] = loadedService
        end
        return self
    end

    return service
end