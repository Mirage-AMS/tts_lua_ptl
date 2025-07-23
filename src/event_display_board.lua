require("mock/default")
require("com/enum_const")
require("com/const_display_board")

---@param option table<string, any>
---@return string[]
local function getDisplayListByOption(option)
    ---@type string[]
    local displayList = {}
    local registerRoleInfo = ROLE_REGISTER_DICT

    local function __getRoleData(roleKey)
        local data = registerRoleInfo[roleKey]
        if not data then
            error("role data not found for role key: " .. tostring(roleKey))
        end
        return data
    end

    local function __isNicknameMatch(nicknameList, searchStr)
        for _, nickname in ipairs(nicknameList) do
            if string.find(nickname, searchStr, 1, true) then
                return true
            end
        end
        return false
    end

    -- get all register role list (apply search text if any)
    local searchText = option.search_text
    local hasSearchText = type(searchText) == "string" and searchText ~= ""
    for roleKey, roleData in pairs(registerRoleInfo) do
        if not hasSearchText then
            table.insert(displayList, roleKey)
        else
            local nicknameList = roleData[KWORD_NICKNAME]
            if nicknameList and #nicknameList > 0 and __isNicknameMatch(nicknameList, searchText) then
                table.insert(displayList, roleKey)
            end
        end
    end

    -- get all reference role list (apply preference if any)
    local preference = option.preference
    local hasPreference = EnumRolePreference(preference) and preference ~= EnumRolePreference.NONE
    if hasPreference then
        local filtered = {}
        for _, roleKey in ipairs(displayList) do
            local roleData = __getRoleData(roleKey)
            if roleData[KWORD_PREFERENCE] == preference then
                table.insert(filtered, roleKey)
            end
        end
        displayList = filtered  -- 直接替换为过滤后的列表
    end

    -- sort by order/difficulty
    local sortBy = option.sort_by
    local compareFunc
    if sortBy == EnumDisplayBoardSort.TIME then
        compareFunc = function(a, b)
            return __getRoleData(a)[KWORD_ORDER] < __getRoleData(b)[KWORD_ORDER]
        end
    elseif sortBy == EnumDisplayBoardSort.DIFFICULTY then
        compareFunc = function(a, b)
            local dataA = __getRoleData(a)
            local dataB = __getRoleData(b)
            local diffA = dataA[KWORD_DIFFICULTY]
            local diffB = dataB[KWORD_DIFFICULTY]
            return diffA < diffB or (diffA == diffB and dataA[KWORD_ORDER] < dataB[KWORD_ORDER])
        end
    else
        error("invalid sort by: " .. tostring(sortBy))
    end
    table.sort(displayList, compareFunc)

    -- is reverse order
    local isReverse = option.is_reverse
    if type(isReverse) == "boolean" and isReverse then
        reverseList(displayList)
    end

    return displayList
end

local function editDisplayBoardButton(index, value)
    local buttonParam = PARAM_SWITCH_BUTTON_CHANGE[index]
    -- quick break if button param is not found
    if not buttonParam then return end
    local param = buttonParam[value]
    -- quick break if param is not found
    if not param then return end

    param.index = index
    GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY):editButton(param)
end

local function editDisplayBoardInputPageNum(page_num)
    local param = {
        index = 0,
        value = page_num,
    }
    GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY):editInput(param)
end


---@param data table<string, any>
---@param forceUpdate boolean?
function updateDisplayBoard(data, forceUpdate)
    local boardDisplay = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)

    -- set the display option
    local oldData = boardDisplay:getDisplayOption()
    boardDisplay:setDisplayOption(data)
    local newData = boardDisplay:getDisplayOption()

    -- get data by display option
    local oldDisplayList = getDisplayListByOption(oldData)
    local newDisplayList = getDisplayListByOption(newData)

    -- update the display board ui
    editDisplayBoardButton(3, newData.preference)
    editDisplayBoardButton(4, newData.sort_by)
    editDisplayBoardButton(5, newData.is_reverse)
    editDisplayBoardInputPageNum(newData.page_num)

    -- update display board
    -- TODO: update display roles by display infos
end

--- a wrapper function to toggle between values
---@param valueType string: type of value to be changed
---@param getValue function: get new value to be changed
---@param debounceTime? number: debounce time in milliseconds
local function onChangeDisplayBoardSetting(valueType, getValue, debounceTime)
    -- use a closure to realize debounce
    debounceTime = debounceTime or 200 -- default debounce time is 200ms
    local lastClickTime = 0.0

    return function()
        -- quick break if debounce time is not passed
        local currentTime = Time.time * 1000
        if currentTime - lastClickTime < debounceTime then return end
        lastClickTime = currentTime

        -- quick break if game mode is not setable
        updateDisplayBoard({[valueType] = getValue()}, false) -- 传递类型和新值
    end
end

function onChangeDisplayBoardRefersh()
    updateDisplayBoard({}, true)
end

onChangeDisplayBoardSettingPrevPage = onChangeDisplayBoardSetting(
    "page_num",
    function()
        local currPageNum = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).page_num
        return math.max(1, currPageNum - 1)
    end
)

onChangeDisplayBoardSettingNextPage = onChangeDisplayBoardSetting(
    "page_num",
    function()
        local currPageNum = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).page_num
        return currPageNum + 1
    end
)

onChangeDisplayBoardSettingPreference = onChangeDisplayBoardSetting(
    "preference",
    function()
        local valueList = {
            EnumRolePreference.NONE,
            EnumRolePreference.GATHERING,
            EnumRolePreference.HUNTING,
            EnumRolePreference.NO_PREFERENCE,
        }
        local currValue = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).preference
        return getNextValInValList(currValue, valueList)
    end
)

onChangeDisplayBoardSettingSortBy = onChangeDisplayBoardSetting(
    "sort_by",
    function()
        local valueList = {EnumDisplayBoardSort.DIFFICULTY, EnumDisplayBoardSort.TIME}
        local currValue = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).sort_by
        return getNextValInValList(currValue, valueList)
    end
)

onChangeDisplayBoardSettingIsReverse = onChangeDisplayBoardSetting(
    "is_reverse",
    function()
        local valueList = {false, true}
        local currValue = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).is_reverse
        return getNextValInValList(currValue, valueList)
    end
)

function onChangeDisplayBoardPageNum(_, _, input_value, stillEditing)
    if stillEditing then return end
    local page_num = tonumber(input_value)
    if type(page_num) ~= "number" then return end
    updateDisplayBoard({["page_num"] = page_num}, false)
end

function onChangeDisplayBoardSearchText(_, _, input_value, stillEditing)
    if stillEditing then return end
    updateDisplayBoard({["search_text"] = input_value}, false)
end