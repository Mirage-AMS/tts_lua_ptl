require("mock/default")
require("com/enum")

---@class EnumDialogConfirm
---@field YES string
---@field NO string
---@field YES_WITH_ANNOTATION string
---@field TIMEOUT string
EnumDialogConfirm = Enum({ YES = "是", NO = "否", YES_WITH_ANNOTATION = "仲裁", TIMEOUT = "超时" })

-- 自执行函数创建闭包环境，封装所有内部状态和函数
local VotingSystem = (function()
    -- 闭包内的私有状态（完全隐藏，外部无法直接访问）
    local isVotingInProgress = false

    --- 计算投票结果并广播
    ---@param initiator PlayerInstance
    ---@param voters PlayerInstance[]
    ---@param results table<PlayerInstance, string>
    ---@param secretAnnotations table<PlayerInstance, boolean>
    ---@param hasTimedOut boolean 是否因超时结束投票
    local function __calculateVotingResult(initiator, voters, results, secretAnnotations, hasTimedOut)
        local initiatorName = initiator.steam_name or initiator.color
        local totalVoters = #voters
        local agreeCount = 0  -- 同意票数
        local opposeCount = 0 -- 反对票数
        local unvotedCount = 0 -- 未投票数（仅超时场景）

        for _, voter in ipairs(voters) do
            local vote = results[voter]
            if vote == EnumDialogConfirm.YES or vote == EnumDialogConfirm.YES_WITH_ANNOTATION then
                agreeCount = agreeCount + 1
            elseif vote == EnumDialogConfirm.NO then
                opposeCount = opposeCount + 1
            else
                -- 未投票（超时场景=TIMEOUT）
                unvotedCount = unvotedCount + 1
            end
        end

        -- 计算通过所需的票数（严格超过半数，即同意票必须大于总人数的1/2）
        local requiredVotes = totalVoters / 2
        local passed = agreeCount > requiredVotes

        local resultMessage = initiatorName .. "宣胜投票结果:\n"
        resultMessage = resultMessage .. "总投票人数: " .. totalVoters .. "\n"
        resultMessage = resultMessage .. "同意: " .. agreeCount .. " 票\n"
        resultMessage = resultMessage .. "反对: " .. opposeCount .. " 票\n"

        if hasTimedOut and unvotedCount > 0 then
            resultMessage = resultMessage .. "未投票: " .. unvotedCount .. " 票（已默认计为反对）\n"
        end

        resultMessage = resultMessage .. "需要通过票数: " .. math.ceil(requiredVotes) .. "\n"
        resultMessage = resultMessage .. "投票" .. (passed and "通过" or "未通过")

        broadcastToAll(resultMessage, DEFAULT_COLOR_WHITE)

        if passed then
            local turnManager = GAME:getTurnManager()
            broadcastToAll(initiatorName .. "达成胜利", DEFAULT_COLOR_WHITE)

            if not turnManager:isWinner(initiator.color) then
                turnManager:addWinners(initiator.color)
            end

            -- 设置为当前回合的最后回合 (进入公平轮)
            if not turnManager:isLastRound() then
                turnManager:setCurrentRoundLastRound()
            end
        end

        -- 重置投票状态
        isVotingInProgress = false
    end

    --- start a voting process for the given initiator.
    ---@param initiator PlayerInstance
    local function __startVotingProcess(initiator)
        -- 如果steam_name为空，则使用color字段作为玩家名称
        local initiatorName = initiator.steam_name or initiator.color

        local playerService = GAME:getPlayerService()
        local seatedPlayerColorList = playerService:getSeatedPlayerColorList()

        ---@type PlayerInstance[]
        local votingPlayers = {}
        for _, player_color in ipairs(seatedPlayerColorList) do
            if player_color ~= initiator.color then
                local playerInstance = playerService:getPlayerObject(player_color)
                if not playerInstance then
                    broadcastToAll("错误：无法获取玩家信息，投票终止", DEFAULT_COLOR_RED)
                    isVotingInProgress = false  -- 重置状态
                    return
                end
                table.insert(votingPlayers, playerInstance)
            end
        end

        if #votingPlayers == 0 then
            broadcastToColor("发起投票失败: 没有可投票的玩家", initiator.color, DEFAULT_COLOR_WHITE)
            isVotingInProgress = false  -- 重置状态
            return
        end

        local timeoutSeconds = 15
        broadcastToAll(initiatorName.." 宣布胜利，正在进行投票... ("..timeoutSeconds.."秒后未投票将默认反对)", DEFAULT_COLOR_WHITE)

        --- 存储投票结果
        ---@type table<PlayerInstance, string>
        local voteResults = {}

        --- 存储人工审核
        ---@type table<PlayerInstance, boolean>
        local secretAnnotations = {}

        local votesReceived = 0
        local isVotingCompleted = false
        local timeoutId

        local function __handleTimeout()
            if isVotingCompleted then return end

            isVotingCompleted = true
            broadcastToAll("投票超时！未投票的玩家将默认计为反对票", DEFAULT_COLOR_WHITE)

            -- 处理未投票的玩家（默认计为反对）
            for _, voter in ipairs(votingPlayers) do
                if not voteResults[voter] then
                    voteResults[voter] = EnumDialogConfirm.TIMEOUT
                    secretAnnotations[voter] = false
                end
            end

            -- 计算超时情况下的投票结果
            __calculateVotingResult(initiator, votingPlayers, voteResults, secretAnnotations, true)
        end

        -- 启动超时计时器
        timeoutId = Wait.time(__handleTimeout, timeoutSeconds)

        for _, voter in ipairs(votingPlayers) do
            voter.showOptionsDialog(
                "请投票决定是否同意 "..initiatorName.." 胜利",
                {EnumDialogConfirm.YES, EnumDialogConfirm.NO},
                2,  -- 默认选择"否"
                function(selectedText, selectedIndex, playerColor)
                    -- 如果投票已结束（超时或全部完成），不再处理
                    if isVotingCompleted then return end

                    -- 记录投票结果
                    voteResults[voter] = selectedText
                    votesReceived = votesReceived + 1

                    -- 如果选择了YES_WITH_ANNOTATION，进行额外的秘密标注处理
                    if selectedText == EnumDialogConfirm.YES_WITH_ANNOTATION then
                        secretAnnotations[voter] = true
                    else
                        secretAnnotations[voter] = false
                    end

                    if votesReceived == #votingPlayers then
                        isVotingCompleted = true
                        Wait.stop(timeoutId)
                        __calculateVotingResult(initiator, votingPlayers, voteResults, secretAnnotations, false)
                    end
                end
            )
        end
    end

    -- 暴露给外部的接口（仅这一个函数可见）
    return {
        --- 玩家点击宣言胜利的入口
        ---@param _ Object
        ---@param player_clicker_color string
        ---@param alt_click boolean
        onPlayerClaimWinner = function(_, player_clicker_color, alt_click)
            if alt_click then return end

            -- 检查是否有投票正在进行（直接访问闭包内的状态）
            if isVotingInProgress then
                broadcastToColor("当前已有投票正在进行中，请等待投票结束后再试", player_clicker_color, DEFAULT_COLOR_WHITE)
                return
            end

            local turnManager = GAME:getTurnManager()

            if not turnManager:isGameStart() or turnManager:isGameEnd() then
                broadcastToColor("必须在游戏进行中宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
                return
            end

            if turnManager:getRound() <= 4 then
                broadcastToColor("游戏开始4轮之内不能宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
                return
            end

            if turnManager:isWinner(player_clicker_color) then
                broadcastToColor("已胜利玩家不能再次宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
                return
            end

            local playerService = GAME:getPlayerService()
            if not playerService:isPlayerDefault(player_clicker_color) then
                broadcastToColor("非参与玩家不能宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
                return
            end

            local playerInstance = playerService:getPlayerObject(player_clicker_color)
            if not playerInstance then
                broadcastToColor("错误：无法获取玩家信息", player_clicker_color, DEFAULT_COLOR_RED)
                return
            end

            if not GAME:isPlayerLegendary(player_clicker_color) then
                broadcastToColor("传奇点不足，不能宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
                return
            end

            playerInstance.showConfirmDialog(
                "你确定要宣布胜利吗？",
                function(player_color)
                    -- 修改闭包内的状态
                    isVotingInProgress = true
                    __startVotingProcess(playerInstance)
                end
            )
        end
    }
end)()

-- 将闭包中暴露的接口赋值给全局，供外部调用（如事件监听）
onPlayerClaimWinner = VotingSystem.onPlayerClaimWinner
