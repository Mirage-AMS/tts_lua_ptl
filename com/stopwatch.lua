---@class Stopwatch
---@field _version string 模块版本号
---@field _records table 内部存储的时间记录数组
---@field _startTime number 码表启动基准时间
---@field _isActive boolean 是否处于计时状态（新增）
---@field reset fun(self: Stopwatch) 重置所有记录
---@field record fun(self: Stopwatch, label: string?) 记录当前时间点
---@field print fun(self: Stopwatch) 打印所有记录
---@field getRecords fun(self: Stopwatch): table 获取所有记录的副本
---@field wrap fun(self: Stopwatch, func: function): function 包装函数以记录各步耗时

--- 初始化码表模块
---@return Stopwatch 包含码表功能的模块实例
function FactoryCreateStopwatch()
    ---@type Stopwatch
    ---@diagnostic disable-next-line: missing-fields
    local stopwatch = {
        _version = "0.2.0",
        _records = {},
        _startTime = 0,
        _isActive = false  -- 新增：标记是否处于wrap创建的计时环境中
    }

    -------------------------------------------------------------------------------
    -- 私有工具函数
    -------------------------------------------------------------------------------

    --- 获取当前时间（基于os.clock()）
    ---@return number
    local function get_current_time()
        return os.clock()
    end

    -------------------------------------------------------------------------------
    -- 公共方法实现
    -------------------------------------------------------------------------------

    --- 重置码表记录
    function stopwatch:reset()
        self._records = {}  -- 清空记录数组
        self._startTime = get_current_time()  -- 重置基准时间
        self._isActive = false  -- 重置时默认非活跃
    end

    --- 核心记录方法（内部使用）
    ---@param label string? 时间点标签（可选）
    function stopwatch:record(label)
        local currentTime = get_current_time() - self._startTime  -- 计算相对时间
        local recordLabel = label or ("Record " .. (#self._records + 1))  -- 自动生成标签

        table.insert(self._records, {
            label = recordLabel,
            time = currentTime,
            timestamp = get_current_time()  -- 保存绝对时间戳用于参考
        })
    end

    --- 打印所有记录
    function stopwatch:print()
        print("Stopwatch Records (v" .. self._version .. "):")
        print("======================================")

        for i, record in ipairs(self._records) do
            -- 格式化输出，左对齐标签，时间保留4位小数
            print(string.format(
                "%d. %-20s %.4f seconds",
                i,
                record.label,
                record.time
            ))

            -- 显示与上一条的间隔时间
            if i > 1 then
                local interval = record.time - self._records[i-1].time
                print(string.format("   %-20s +%.4f seconds", "", interval))
            end
        end

        print("======================================")
    end

    --- 获取所有记录的副本（避免外部直接修改内部数据）
    ---@return table
    function stopwatch:getRecords()
        local copy = {}
        for i, record in ipairs(self._records) do
            copy[i] = {
                label = record.label,
                time = record.time,
                timestamp = record.timestamp
            }
        end
        return copy
    end

    --- 改进的wrap方法：通过闭包绑定实例，无需修改全局环境
    ---@param func function 需要被包装的函数，内部可直接调用recordStep()
    ---@return function 包装后的函数
    function stopwatch:wrap(func)
        -- 创建一个局部的recordStep函数，自动绑定当前Stopwatch实例
        local function recordStep(label)
            -- 只有在活跃状态下才记录（避免非包装调用时产生记录）
            if stopwatch._isActive then
                stopwatch:record(label)
            end
        end

        -- 返回包装后的函数
        return function(...)
            -- 保存当前状态（支持嵌套wrap）
            local prevActive = stopwatch._isActive
            local prevRecords = stopwatch:getRecords()
            local prevStartTime = stopwatch._startTime

            -- 初始化当前计时
            stopwatch:reset()
            stopwatch._isActive = true  -- 标记为活跃状态
            stopwatch:record("Function start")

            -- 执行被包装的函数，通过闭包提供recordStep
            local results = {func(recordStep, ...)}  -- 第一个参数是recordStep函数

            -- 记录结束时间
            stopwatch:record("Function end")
            stopwatch._isActive = prevActive  -- 恢复之前的活跃状态

            -- 如果是顶层调用，保留记录；如果是嵌套调用，合并记录
            if not prevActive then
                -- 顶层调用：保持当前记录
            else
                -- 嵌套调用：合并记录到父级
                stopwatch._records = prevRecords
                stopwatch._startTime = prevStartTime
            end

            return table.unpack(results)
        end
    end

    -- 初始化时触发一次重置
    stopwatch:reset()

    return stopwatch
end

-- 全局实例化
Stopwatch = FactoryCreateStopwatch()

-- 使用示例（即插即用特性保留）
do
    ---- 步骤函数现在接收recordStep作为第一个参数，但调用方式依然简洁
    --local function dataProcessingStep01(recordStep, input)
    --    recordStep("Data validation")  -- 直接调用局部函数，无需指定实例
    --    if type(input) ~= "table" then
    --        return {success = false, error = "Invalid input"}
    --    end
    --    os.execute("ping -n 2 127.0.0.1 > nil")  -- 模拟耗时操作
    --    return {success = true, data = input}
    --end
    --
    --local function dataProcessingStep02(recordStep, input)
    --    recordStep("Data cleaning")
    --    local cleaned = {}
    --    for _, value in ipairs(input.data) do
    --        if type(value) == "number" then
    --            table.insert(cleaned, value)
    --        end
    --    end
    --    os.execute("ping -n 2 127.0.0.1 > nil")  -- 模拟耗时操作
    --    return cleaned
    --end
    --
    ---- 主函数同样接收recordStep作为第一个参数
    --local function dataProcessing(recordStep, input)
    --    -- 如果未提供 recordStep（直接调用时），使用空函数
    --    recordStep = recordStep or function() end
    --
    --    local validated = dataProcessingStep01(recordStep, input)
    --    if not validated.success then
    --        return {success = false, error = validated.error}
    --    end
    --    local cleaned = dataProcessingStep02(recordStep, validated)
    --    recordStep("Final processing")  -- 中间步骤也可以记录
    --    return {success = true, result = cleaned}
    --end
    --
    ---- 包装函数（即插即用特性）
    --local wrappedProcess = Stopwatch:wrap(dataProcessing)
    --
    ---- 调用包装函数（无需传递recordStep，由wrap自动注入）
    --wrappedProcess({10, 20, 30, "invalid", 40})
    --Stopwatch:print()
    --
    ---- 支持多实例（解决之前的冲突问题）
    --local sw2 = FactoryCreateStopwatch()
    --local wrappedProcess2 = sw2:wrap(dataProcessing)
    --wrappedProcess2({1, 2, 3, "test", 5})
    --print("\nSecond stopwatch results:")
    --sw2:print()
end