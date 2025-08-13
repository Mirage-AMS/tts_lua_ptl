require("com/json")
require("com/stopwatch")

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

--- Checks if two lists are equal.
---@param list1 table?
---@param list2 table?
---@return boolean
function isListEqual(list1, list2)
    if type(list1) ~= "table" or type(list2) ~= "table" then
        return false
    end
    if #list1 ~= #list2 then
        return false
    end

    for i = 1, #list1 do
        if type(list1[i]) ~= type(list2[i]) or list1[i] ~= list2[i] then
            return false
        end
    end

    return true
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

--- 判断两个字符串是否模糊匹配
---@param str1 string 第一个字符串
---@param str2 string 第二个字符串
---@return boolean 返回两个字符串是否模糊匹配
function isFuzzyMatch(str1, str2)
    -- 转换为小写以实现不区分大小写的匹配
    local lowerStr1 = string.lower(str1)
    local lowerStr2 = string.lower(str2)

    -- 检查一个字符串是否包含另一个字符串的部分内容
    return string.find(lowerStr1, lowerStr2, 1, true) ~= nil
        or string.find(lowerStr2, lowerStr1, 1, true) ~= nil
end


--- 模糊搜索 (已进行性能测试, 10 万条记录的最大耗时约 0.677s)
---@param data table 数据表，键为关键字，值为一个包含匹配字符串的列表
---@param searchStr string 搜索字符串
---@return table result 包含所有匹配关键字符串的列表
function fuzzySearch(data, searchStr)
    local result = {}

    -- 遍历数据中的每一个关键字符串
    for key, matches in pairs(data) do
        -- 检查该关键字符串对应的所有匹配项
        for _, matchStr in ipairs(matches) do
            if isFuzzyMatch(matchStr, searchStr) then
                table.insert(result, key)
                break  -- 找到一个匹配项即可，无需检查其他
            end
        end
    end

    return result
end