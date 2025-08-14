require("mock/default")
require("com/enum")

--showOptionsDialog(description, options, default_value, callback)
-- description: Description of what the player is choosing.
-- options: Table of string options.
-- default_value: Optional default value, an integer index into the options table. Note you may alternatively use the option string itself.
-- callback: Callback to execute if they click OK. Will be called as callback(selected_text, selected_index, player_color)

---@class EnumDialogConfirm
---@field YES string
---@field NO string
---@field YES_WITH_ANNOTATION string
---@field TIMEOUT string
EnumDialogConfirm = Enum({ YES = "是", NO = "否", YES_WITH_ANNOTATION = "仲裁", TIMEOUT = "超时" })

--- calculate voting result and broadcast it to all players.
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

    -- 统计票数
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

    -- 计算通过所需的票数（超过半数，向上取整）
    local requiredVotes = math.ceil(totalVoters / 2)
    local passed = agreeCount >= requiredVotes

    -- 向所有玩家展示公开结果
    local resultMessage = initiatorName .. "宣胜投票结果:\n"
    resultMessage = resultMessage .. "总投票人数: " .. totalVoters .. "\n"
    resultMessage = resultMessage .. "同意: " .. agreeCount .. " 票\n"
    resultMessage = resultMessage .. "反对: " .. opposeCount .. " 票\n"

    -- 如果是超时结束，显示未投票数量
    if hasTimedOut and unvotedCount > 0 then
        resultMessage = resultMessage .. "未投票: " .. unvotedCount .. " 票（已默认计为反对）\n"
    end

    resultMessage = resultMessage .. "需要通过票数: " .. requiredVotes .. "\n"
    resultMessage = resultMessage .. "投票" .. (passed and "通过" or "未通过")

    broadcastToAll(resultMessage, DEFAULT_COLOR_WHITE)
    ---@TODO: 这里可以添加对YES_WITH_ANOTATION的特殊处理逻辑，例如记录秘密标注或进行额外的操作

    if passed then
        local turnManager = GAME:getTurnManager()
        if not turnManager:isWinner(initiator.color) then
            turnManager:addWinners(initiator.color)
        end

        -- 设置为当前回合的最后回合 (进入公平轮)
        if not turnManager:isLastRound() then
            turnManager:setCurrentRoundLastRound()
        end
    end

end

--- start a voting process for the given initiator.
---@param initiator PlayerInstance
local function __startVotingProcess(initiator)
    -- 如果steam_name为空，则使用color字段作为玩家名称
    local initiatorName = initiator.steam_name or initiator.color

    local playerService = GAME:getPlayerService()
    local seatedPlayerColorList = playerService:getSeatedPlayerColorList()

    ---@type PlayerInstance[]
    local votingPlayers = {}  -- 存储需要投票的玩家（排除发起者）
    -- 筛选出需要投票的玩家（排除发起者）
    for _, player_color in ipairs(seatedPlayerColorList) do
        if player_color ~= initiator.color then
            local playerInstance = playerService:getPlayerObject(player_color)
            if not playerInstance then
                error("fatal error: playerInstance "..player_color.."is nil")
            end
            table.insert(votingPlayers, playerInstance)
        end
    end

    -- 如果没有其他玩家，则无法进行投票
    if #votingPlayers == 0 then
        broadcastToColor("发起投票失败: 没有可投票的玩家", initiator.color, DEFAULT_COLOR_WHITE)
        return
    end

    -- 广播投票开始信息，包含超时提示
    local timeoutSeconds = 30  -- 超时时间设置为30秒
    broadcastToAll(initiatorName.." 宣布胜利，正在进行投票... ("..timeoutSeconds.."秒后未投票将默认反对)", DEFAULT_COLOR_WHITE)

    --- 存储投票结果
    ---@type table<PlayerInstance, string>
    local voteResults = {}

    --- 存储人工审核
    ---@type table<PlayerInstance, boolean>
    local secretAnnotations = {}

    local votesReceived = 0  -- 已收到的投票数
    local isVotingCompleted = false  -- 标记投票是否已结束
    local timeoutId  -- 超时计时器ID

    -- 超时处理函数
    local function __handleTimeout()
        if isVotingCompleted then return end  -- 防止重复处理

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

    -- 向每个玩家发送投票请求
    for _, voter in ipairs(votingPlayers) do
        voter.showOptionsDialog(
            "请投票决定是否同意 "..initiatorName.." 胜利\n(超时未投票将默认反对)",
            {EnumDialogConfirm.YES, EnumDialogConfirm.NO, EnumDialogConfirm.YES_WITH_ANNOTATION},
            1,  -- 默认选择"是"
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

                -- 当所有玩家都完成投票后，计算结果
                if votesReceived == #votingPlayers then
                    isVotingCompleted = true
                    Wait.stop(timeoutId)  -- 停止超时计时器
                    __calculateVotingResult(initiator, votingPlayers, voteResults, secretAnnotations, false)
                end
            end
        )
    end
end

--- player click to claim winner.
---@param _ Object
---@param player_clicker_color string
---@param alt_click boolean
function onPlayerClaimWinner(_, player_clicker_color, alt_click)
    if alt_click then return end
    local turnManager = GAME:getTurnManager()
    if turnManager:getRound() <= 4 then
        broadcastToColor("不能在4回合内宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
        return
    end

    if turnManager:isWinner(player_clicker_color) then
        broadcastToColor("你已经胜利，不能再次宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
        return
    end

    local playerService = GAME:getPlayerService()
    if not playerService:isPlayerDefault(player_clicker_color) then
        broadcastToColor("非参与玩家不能宣言胜利", player_clicker_color, DEFAULT_COLOR_WHITE)
        return
    end

    local playerInstance = playerService:getPlayerObject(player_clicker_color)
    if not playerInstance then
        error("fatal error: playerInstance is nil")
    end

    playerInstance.showOptionsDialog(
        "要宣布胜利吗？",
        {EnumDialogConfirm.YES, EnumDialogConfirm.NO},
        2, -- 默认选项为NO
        function(selected_text, selected_index, player_color)
            if selected_text == EnumDialogConfirm.YES then
                __startVotingProcess(playerInstance)
            end
        end
    )
end
