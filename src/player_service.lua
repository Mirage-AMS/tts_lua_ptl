require("src/private_service")

---@return PlayerService
function FactoryCreatePlayerService()
    ---@class PlayerService
    local service = {
        players = {}
    }

    function service:isPlayerDefault(player_color)
        return isValInValList(player_color, DEFAULT_PLAYER_COLOR_LIST)
    end

    ---@return PrivateService
    function service:getPlayer(player_color)
        if player_color and self.players[player_color] then
            return self.players[player_color]
        end
        error("Player not found for color: " .. tostring(player_color))
    end

    ---@return table
    function service:getPlayerObjectList()
        return Player.getPlayers()
    end

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

    ---@param data table
    ---@return PlayerService
    function service:onLoad(data)
        local players = data.players or {}
        for k, v in pairs(players) do
            -- 创建并加载玩家数据，增加错误检查
            local player = FactoryCreatePrivateService()
            if player then
                self.players[k] = player:onLoad(v or {})
            else
                print("Error: Failed to create player service for color " .. tostring(k))
            end
        end
        return self
    end

    return service
end