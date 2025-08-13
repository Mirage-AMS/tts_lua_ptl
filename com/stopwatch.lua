---@class Stopwatch
---@field _version string 模块版本号
---@field _records table 内部存储的时间记录数组
---@field _startTime number 码表启动基准时间
---@field reset fun(self: Stopwatch) 重置所有记录
---@field record fun(self: Stopwatch, label: string?) 记录当前时间点
---@field print fun(self: Stopwatch) 打印所有记录
---@field getRecords fun(self: Stopwatch): table 获取所有记录的副本

--- 初始化码表模块
---@return Stopwatch 包含码表功能的模块实例
function FactoryCreateStopwatch()
    ---@type Stopwatch
    ---@diagnostic disable-next-line: missing-fields
    local stopwatch = {
        _version = "0.1.0",
        _records = {},
        _startTime = 0
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
    end

    --- 记录当前时间点
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

    -- 初始化时触发一次重置
    stopwatch:reset()

    return stopwatch
end

-- 全局实例化，适配静态编译调用
Stopwatch = FactoryCreateStopwatch()
