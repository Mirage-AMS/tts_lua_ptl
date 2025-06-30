-- CoroutineManager.lua
CoroutineManager = {}
CoroutineManager.__index = CoroutineManager

-- 创建新的协程管理器实例
function CoroutineManager.new()
    local instance = setmetatable({}, CoroutineManager)
    instance.coroutines = {}  -- 存储所有协程的状态
    instance.nextId = 1       -- 下一个协程ID
    return instance
end

-- 创建并注册一个新协程
function CoroutineManager:create(func, ...)
    local co = coroutine.create(func)
    local id = self.nextId
    self.nextId = self.nextId + 1

    -- 存储协程信息
    self.coroutines[id] = {
        co = co,
        status = "suspended",
        args = {...}
    }

    return id
end

-- 恢复执行指定ID的协程
function CoroutineManager:resume(id, ...)
    local coro = self.coroutines[id]
    if not coro then
        return false, "Coroutine not found with id: " .. id
    end

    if coroutine.status(coro.co) == "dead" then
        return false, "Coroutine is already dead"
    end

    -- 首次调用传递创建时的参数，后续调用传递resume的参数
    local args = coro.args
    coro.args = nil  -- 清空首次参数，避免重复使用

    local success, result = nil, nil
    if args and #args > 0 and coroutine.status(coro.co) == "suspended" then
        success, result = coroutine.resume(coro.co, table.unpack(args))
    else
        success, result = coroutine.resume(coro.co, ...)
    end

    coro.status = coroutine.status(coro.co)

    if not success then
        self:remove(id)  -- 出错时自动移除协程
    end

    return success, result
end

-- 更新所有协程，返回仍在运行的协程数量
function CoroutineManager:update()
    local runningCount = 0
    local toRemove = {}

    for id, coro in pairs(self.coroutines) do
        if coro.status ~= "dead" then
            local success, result = self:resume(id)
            if not success or coro.status == "dead" then
                table.insert(toRemove, id)
            else
                runningCount = runningCount + 1
            end
        else
            table.insert(toRemove, id)
        end
    end

    -- 移除已完成或出错的协程
    for _, id in ipairs(toRemove) do
        self:remove(id)
    end

    return runningCount
end

-- 停止并移除指定ID的协程
function CoroutineManager:remove(id)
    self.coroutines[id] = nil
end

-- 停止并移除所有协程
function CoroutineManager:clear()
    self.coroutines = {}
end

-- 获取指定ID协程的状态
function CoroutineManager:getStatus(id)
    local coro = self.coroutines[id]
    return coro and coro.status or "not found"
end

-- 获取所有协程的状态
function CoroutineManager:getAllStatus()
    local status = {}
    for id, coro in pairs(self.coroutines) do
        status[id] = coro.status
    end
    return status
end

return CoroutineManager