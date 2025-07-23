function isValInValList(value, list)
    for _, val in ipairs(list) do if val == value then return true end end
    return false
end

function isObjInObjList(target, list)
    if target == nil then return false end
    local target_id = target.getGUID()
    for _, compare in ipairs(list) do
        local compare_id = compare.getGUID()
        if target_id == compare_id then return true end
    end
    return false
end

function isAnyObjInObjList(target_list, list)
    if target_list == nil or target_list == {} then return false end
    for _, target in ipairs(target_list) do
        if isObjInObjList(target, list) then return true end
    end
    return false
end

function getValIdxInValList(value, list)
    for idx, val in ipairs(list) do if val == value then return idx end end
    return nil
end

--- Returns the next value in a list, or nil if there is no such value.
---@param value any The value to find the next one for.
---@param list table The list to search in.
function getNextValInValList(value, list)
    local currentIdx = getValIdxInValList(value, list)
    if currentIdx == nil then
        return nil
    end

    local nextIdx = currentIdx + 1
    if nextIdx > #list then
        nextIdx = 1
    end

    return list[nextIdx]
end

function mergeList(l1, l2)
    if not l1 then return l2 end
    if not l2 then return l1 end
    for _, v in ipairs(l2) do
        table.insert(l1, v)
    end
    return l1
end

---@param list table The list to reverse.
---@return table? reversed The reversed list.
function reverseList(list)
    -- 检查列表是否有效且至少有两个元素
    if not list or #list < 2 then
        return list
    end

    local i, j = 1, #list
    -- 只需要遍历到列表的中间位置
    while i < j do
        -- 交换对称位置的元素
        list[i], list[j] = list[j], list[i]
        -- 移动索引
        i = i + 1
        j = j - 1
    end

    return list
end

function tableToString(tbl)
    local seen = {}
    local function _tostring(t)
        if type(t) ~= "table" then
            return tostring(t)
        end
        if seen[t] then
            return "<cycle>"
        end
        seen[t] = true

        local parts = {}
        for k, v in pairs(t) do
            local keyStr = type(k) == "string" and k:match("^[%a_][%a%d_]*$") and k or "[".._tostring(k).."]"
            table.insert(parts, keyStr.."=".._tostring(v))
        end
        return "{"..table.concat(parts, ", ").."}"
    end
    return _tostring(tbl)
end

function deepCopy(orig)
    -- 记录已复制的对象，解决循环引用
    local copies = {}

    local function _copy(obj)
        if type(obj) ~= 'table' then
            return obj
        end
        if copies[obj] then
            return copies[obj]
        end

        local copy = {}
        copies[obj] = copy

        for k, v in pairs(obj) do
            copy[_copy(k)] = _copy(v)
        end

        setmetatable(copy, _copy(getmetatable(obj)))
        return copy
    end

    return _copy(orig)
end

function mergeTable(dst, src)
    if not dst then
        return src
    end

    if not src then
        return dst
    end

    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then
                dst[k] = {}
            end
            dst[k] = deepCopy(v)  -- 使用现有的 deepcopy 函数
        else
            dst[k] = v
        end
    end

    return dst
end