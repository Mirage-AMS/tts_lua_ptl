require("mock/default")
require("com/enum_const")
require("com/const_display_board")
require("com/const_dev_board")

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
            if string.find(nickname, searchStr) then
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
    local buttonParam = PARAM_DISPLAY_BOARD_SWITCH_BUTTON_CHANGE[index]
    -- quick break if button param is not found
    if not buttonParam then return end
    local param = buttonParam[value]
    -- quick break if param is not found
    if not param then return end

    param.index = index
    GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY):editButton(param)
end

local function editDisplayBoardInputPageNum(page_num)
    Wait.frames(
        function()
            local param = {
                index = 0,
                value = page_num,
            }
            GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY):editInput(param)
        end,
        1
    )
end

local function clearDisplayBoardZone()
    local zone = GAME:getPublicItemManager():getZone(NAME_ZONE_DISPLAY_BOARD)
    if not zone then
        error("fatal error: display board zone is not found")
    end
    local deckSlot = zone.deck_slot
    if not deckSlot then
        error("fatal error: "..zone.name..".deck_slot is nil")
    end
    for _, card in ipairs(deckSlot:getCardObjects()) do
        card.destruct()
    end
end

---@param infoList string[]
local function setupRoleItem(infoList)
    if not infoList or #infoList == 0 then return end
    local boardDisplay = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)

    -- gather items info from register role info
    local registerRoleInfo = ROLE_REGISTER_DICT
    local items = {}
    for boardIdx, roleKey in ipairs(infoList) do
        local roleData = registerRoleInfo[roleKey] or {}
        local roleItems = roleData[KWORD_ITEM]
        if roleItems and #roleItems > 0 then
            for _, item in ipairs(roleItems) do
                local origin = item.origin
                local prefix = item.prefix
                if not items[origin] then
                    items[origin] = {}
                end
                if not items[origin][prefix] then
                    items[origin][prefix] = {}
                end
                local copyItem = deepCopy(item)
                copyItem.loc_id = boardIdx
                copyItem.name = roleKey
                table.insert(items[origin][prefix], copyItem)
            end
        end
    end

    -- dev deck
    local publicService = GAME:getPublicService()

    local boardPattern = ROLE_DISPLAY_BOARD_PATTERN
    local dx, dz = boardPattern.dx, boardPattern.dz
    local dxx, dzz = boardPattern.dxx, boardPattern.dzz
    local dxxx, dzzz = boardPattern.dxxx, boardPattern.dzzz

    local itemFromDevDeck = items[EnumItemOrigin.DEV_DECK]
    if itemFromDevDeck then
        for prefix, itemList in pairs(itemFromDevDeck) do
            if itemList and #itemList > 0 then
                local deck = publicService:getDevDeck(prefix)
                if not deck or not isCardLike(deck) then
                    error("fatal error: dev deck "..prefix.." is not found")
                end

                for _, item in ipairs(itemList) do
                    local deckIndex = item.index
                    local col = (item.loc_id % 2 == 1) and 1 or 2
                    local row = math.ceil(item.loc_id / 2)
                    local offsets = {
                        [1] = { x = col, z = row, dx = dx, dz = dz },
                        [2] = { x = item.loc_idx or 1, z = 1, dx = dxx, dz = dzz },
                        [3] = { x = item.loc_idxx or 1, z = 1, dx = dxxx, dz = dzzz }
                    }
                    local pos = boardDisplay:getPosition() + boardPattern.origin
                    for index, offset in ipairs(offsets) do
                        pos = getOffsetPosition(pos, offset.x, offset.z, offset.dx, offset.dz)
                        -- special case for 3rd pattern shift, shift up a little bit
                        if index == 3 and offset.x > 1 then
                            pos = pos + Vector(0, 0.05, 0) * (offset.x - 1)
                        end
                    end
                    local clonedPos = pos + Vector(0, 2, 0)
                    local clonedDeck = deck.clone({position = clonedPos})
                    local takeParam = {
                        index = deckIndex - 1,
                        position = pos,
                        flip = true
                    }
                    clonedDeck.takeObject(takeParam).setLock(true)
                    clonedDeck.destruct()
                end
            end
        end
    end
end

---@param data table<string, any>
---@param forceUpdate boolean?
function updateDisplayBoard(data, forceUpdate)
    local boardDisplay = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)

    -- fetch old data
    local oldData = boardDisplay:getDisplayOption()
    local oldDisplayList = getDisplayListByOption(oldData)
    local oldInfoList = boardDisplay:getPageInfo(oldDisplayList)

    -- update display option
    boardDisplay:setDisplayOption(data)
    local newData = boardDisplay:getDisplayOption()
    local newDisplayList = getDisplayListByOption(newData)
    local newInfoList = boardDisplay:getPageInfo(newDisplayList)

    -- update the display board ui
    config = {
        [1] = boardDisplay.page_num==1,
        [2] = boardDisplay.page_num==boardDisplay.max_page_num,
        [3] = boardDisplay.preference,
        [4] = boardDisplay.sort_by,
        [5] = boardDisplay.is_reverse,
    }
    for i = 1, #config do
        editDisplayBoardButton(i, config[i])
    end
    editDisplayBoardInputPageNum(newData.page_num)

    -- check if display list is changed
    local isDisplayListChanged = not isListEqual(oldInfoList, newInfoList)
    if not forceUpdate and not isDisplayListChanged then return end

    -- clear display board zone
    clearDisplayBoardZone()

    -- gather card info
    setupRoleItem(newInfoList)
end

--- a wrapper function to toggle between values
---@param valueType string: type of value to be changed
---@param getValue function: get new value to be changed
---@param debounceTime? number: debounce time in milliseconds
local function onChangeDisplayBoardSetting(valueType, getValue, debounceTime)
    -- use a closure to realize debounce
    debounceTime = debounceTime or 500 -- default debounce time is 200ms
    local lastClickTime = 0.0

    return function()
        -- quick break if debounce time is not passed
        local currentTime = Time.time * 1000
        if currentTime - lastClickTime < debounceTime then return end
        lastClickTime = currentTime

        -- if refresh is triggered, update the display board directly
        if valueType == "refresh" then
            updateDisplayBoard({}, true)
            return
        end

        -- change other settings
        local displayBoard = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)
        local currData = displayBoard[valueType]
        local newData = getValue()
        if currData == newData then return end

        local updateData = {[valueType] = newData}
         -- reset page num to 1 when changing other settings
        if valueType ~= "page_num" then
            updateData.page_num = 1
        end
        updateDisplayBoard(updateData, false)
    end
end

onChangeDisplayBoardPageRefresh = onChangeDisplayBoardSetting(
    "refresh",
    function() end
)

onChangeDisplayBoardPagePrev = onChangeDisplayBoardSetting(
    "page_num",
    function()
        local currPageNum = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).page_num
        return math.max(1, currPageNum - 1)
    end
)

onChangeDisplayBoardPageNext = onChangeDisplayBoardSetting(
    "page_num",
    function()
        local displayBoard = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)
        local currPageNum = displayBoard.page_num
        local maxPageNum = displayBoard.max_page_num
        return math.min(maxPageNum, currPageNum + 1)
    end
)

--- 使用闭包来创建一个输入处理器, 它可以更新值并执行相应的操作。
---@param valueType string
---@param debounceTime? number
---@return table
local function createInputHandler(valueType, debounceTime)
    local currentValue  -- 用闭包变量存储当前值
    local handler = onChangeDisplayBoardSetting(
        valueType,
        function() return currentValue end,  -- 访问闭包中的currentValue
        debounceTime or 0
    )

    -- 返回更新值和执行的接口
    return {
        setValue = function(value)
            currentValue = value
        end,
        execute = handler
    }
end

local pageNumHandler = createInputHandler("page_num", 0)
local searchTextHandler = createInputHandler("search_text", 0)

onChangeDisplayBoardPageNum = function(_, _, input_value, stillEditing)
    if stillEditing then return end
    input_value = tonumber(input_value)
    if type(input_value) == "number" then
        pageNumHandler.setValue(input_value)
        pageNumHandler.execute()
    end
end

onChangeDisplayBoardSettingSearchText = function(_, _, input_value, stillEditing)
    if stillEditing then return end
    searchTextHandler.setValue(input_value)
    searchTextHandler.execute()
end

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