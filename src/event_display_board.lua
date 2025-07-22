require("mock/default")
require("com/enum_const")
require("com/const_display_board")

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
    boardDisplay:setDisplayOption(data)
    local newData = boardDisplay:getDisplayOption()

    -- get data by display option
    -- TODO: get display infos by display option

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