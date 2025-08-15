require("mock/default")
require("com/const_request")
require("com/basic")
require("com/request")

--- closure for request system
local RequestSystem = (function()
    local url = REQUEST_API_URL
    local gameId = REQUEST_GAME_ID
    local defaultHeader = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = REQUEST_AUTH_TOKEN,
    }

    ---@param api string
    ---@param header table?
    ---@param data table?
    ---@param callback fun(response: WebRequestInstance)?
    local request = function(api, header, data, callback)
        local apiUrl = url .. api
        local apiHeader = deepCopy(defaultHeader)
        if type(header) == 'table' then
            for k, v in pairs(header) do
                apiHeader[k] = v
            end
        end
        local apiData = {
            id = gameId,
            data = data
        }

        ---@type Request
        local req = Request()
        req:setUrl(apiUrl)
        :setHeaders(apiHeader)
        :setMethod(EnumRequestMethod.POST)
        :setData(apiData)
        :setHandler(callback)
        :send()
    end

    local initGameRecord = function()
        ---@param response WebRequestInstance
        local callback = function(response)
            local recordId = nil
            local success, jsonData = pcall(Json.decode, response.text)

            if not success then
                print("JSON 解析失败：".. response.text)
                return
            end
            if type(jsonData) ~= "table" then
                print("响应格式错误：".. tableToString(jsonData))
                return
            end

            recordId = jsonData.id
            GAME:getTurnManager():setRecordId(recordId)
        end

        local data = {
            player = {}
        }
        local playerService = GAME:getPlayerService()
        for _, player_color in ipairs(playerService:getSeatedPlayerColorList()) do
            local steamId = playerService:getPlayerSteamId(player_color)
            if steamId and type(steamId) == "string" and steamId ~= "" then
                table.insert(data.player, steamId)
            else
                print("无效的 steam_id：", player_color)
            end
        end

        request("/start", nil, data, callback)
    end

    local recordGame = function()
        local data = {
            public_service = GAME:getPublicService():onSnapshot(),
            player_service = GAME:getPlayerService():onSnapshot(),
        }
        request("/record", nil, data, nil)
    end

    local endGameRecord = function()
        local data = {
            player = {}
        }
        local winners = GAME:getTurnManager():getWinners()
        local playerService = GAME:getPlayerService()
        for _, player_color in ipairs(winners) do
            local steamId = playerService:getPlayerSteamId(player_color)
            if steamId and type(steamId) == "string" and steamId ~= "" then
                table.insert(data.player, steamId)
            else
                print("无效的 steam_id：", player_color)
            end
        end

        request("/end", nil, data, nil)
    end

    return {
        initGameRecord = initGameRecord,
        recordGame = recordGame,
        endGameRecord = endGameRecord
    }
end)()

-- expose functions
requestInitGameRecord = RequestSystem.initGameRecord
requestSnapshotGame = RequestSystem.recordGame
requestEndGameRecord = RequestSystem.endGameRecord
