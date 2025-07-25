require("mock/default")
require("com/enum_const")
require("com/const_dev_board")
require("com/const_display_board")

--- 为了方便搜索，将角色注册信息转换为仅包含昵称的表。
---@type table<string, string[]>
local registerRoleInfoForSearch = {}
for k, v in pairs(ROLE_REGISTER_DICT) do
    registerRoleInfoForSearch[k] = v[KWORD_NICKNAME]
end

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

    -- get all register role list (apply search text if any)
    local searchText = option.search_text
    local hasSearchText = type(searchText) == "string" and searchText ~= ""
    if hasSearchText then
        displayList = fuzzySearch(registerRoleInfoForSearch, searchText)
    else
        for roleKey, _ in pairs(registerRoleInfo) do
            table.insert(displayList, roleKey)
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

--- get shift position for display board item
---@param item {loc_id: number, loc_idx?: number, loc_idxx?: number}
---@return Vector
local function getDisplayBoardItemShift(item)
    local Y_OFFSET = Vector(0, 0.05, 0)
    local boardPattern = ROLE_DISPLAY_BOARD_PATTERN
    local originShift = boardPattern.origin
    local dx, dz = boardPattern.dx, boardPattern.dz
    local dxx, dzz = boardPattern.dxx, boardPattern.dzz
    local dxxx, dzzz = boardPattern.dxxx, boardPattern.dzzz

    local locId = item.loc_id
    local col = (locId % 2 == 1) and 1 or 2
    local row = math.ceil(locId / 2)

    local pos = originShift
    pos = getOffsetPosition(pos, col, row, dx, dz)
    local x2 = item.loc_idx or 1
    pos = getOffsetPosition(pos, x2, 1, dxx, dzz)
    local x3 = item.loc_idxx or 1
    pos = getOffsetPosition(pos, x3, 1, dxxx, dzzz)
    if x3 > 1 then
        pos = pos + Y_OFFSET * (x3 - 1)
    end

    return pos
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
        if roleItems ~= nil and #roleItems > 0 then
            for _, item in ipairs(roleItems) do
                local copyItem = deepCopy(item)
                copyItem.loc_id = boardIdx
                local origin = item.origin
                local prefix = item.prefix

                items[origin] = items[origin] or {}
                items[origin][prefix] = items[origin][prefix] or {}
                table.insert(items[origin][prefix], copyItem)
            end
        end
    end

    local publicService = GAME:getPublicService()

    -- dev deck
    local itemFromDevDeck = items[EnumItemOrigin.DEV_DECK]
    if itemFromDevDeck then
        for prefix, itemList in pairs(itemFromDevDeck) do
            if itemList and #itemList > 0 then
                local deck = publicService:getDevDeck(prefix)
                if not deck or not isCardLike(deck) then
                    error("fatal error: dev deck "..prefix.." is not found")
                end

                for _, item in ipairs(itemList) do
                    local isFlip = true
                    if item.flip ~= nil then isFlip = item.flip end
                    local rot = isFlip and __CARD_ROTATION_FACE_UP or __CARD_ROTATION_FACE_DOWN
                    local pos = boardDisplay:getPosition() + getDisplayBoardItemShift(item)
                    local clonedObject = deck.clone({})
                    local takeParam = {index = item.index - 1}
                    local takeItem = clonedObject.takeObject(takeParam)
                    takeItem.setLock(true)
                    takeItem.setPosition(pos)
                    takeItem.setRotation(rot)
                    clonedObject.destruct()
                end
            end
        end
    end

    --- containers
    local itemFromContainer = items[EnumItemOrigin.DEV_CONTAINER_ITEM]
    if itemFromContainer then
        for prefix, itemList in pairs(itemFromContainer) do
            if itemList and #itemList > 0 then
                local container = publicService:getItemManager():getContainer(prefix)
                if not container then
                    error("fatal error: container "..prefix.." is not found")
                end
                if not container.object then
                    error("fatal error: container "..prefix.." is not loaded")
                end

                for _, item in ipairs(itemList) do
                    local isFlip = true
                    if item.flip ~= nil then isFlip = item.flip end
                    local rot = isFlip and __CARD_ROTATION_FACE_UP or __CARD_ROTATION_FACE_DOWN
                    local pos = boardDisplay:getPosition() + getDisplayBoardItemShift(item)
                    local clonedObject = container.object.clone({})
                    local takeItem = clonedObject.takeObject()
                    takeItem.setPosition(pos)
                    takeItem.setLock(true)
                    takeItem.setRotation(rot)
                    clonedObject.destruct()
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
    local config = {
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
---@return {isDebouncing: fun(), setDebounceTime: fun(debounceTime: number), execute:fun(data: table<string, any>)}
local function createUpdateHandler()
    ---@type number
    local lastClickTime = 0.0
    ---@type number
    local debounceTime = 200

    ---@return boolean
    local function isDebouncing()
        local currentTime = Time.time * 1000
        return currentTime - lastClickTime < debounceTime
    end

    ---@param newDebounceTime number
    local function setDebounceTime(newDebounceTime)
        debounceTime = newDebounceTime
    end

    local function execute(data)
        if isDebouncing() then return end
        lastClickTime = Time.time * 1000

        if GAME:getPublicService():isDevMode() then
            broadcastToAll("Dev-Mode is enabled, please disable it first")
            return
        end

        -- change other settings
        local displayBoard = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)
        local currData = displayBoard:getDisplayOption()
        local isChanged = false
        local isForceRefresh = false
        for k, v in pairs(data) do
            if k == "refresh" then
                isForceRefresh = true
            elseif currData[k] ~= v then
                isChanged = true
            end
        end
        if not isChanged and not isForceRefresh then return end

        -- core logic
        updateDisplayBoard(data, isForceRefresh)
    end

    return {
        isDebouncing = isDebouncing,
        setDebounceTime = setDebounceTime,
        execute = execute,
    }
end

--- all display functions share the same debounce logic
local updateHandler = createUpdateHandler()

function onChangeDisplayBoardPageRefresh(_, _, alt_click)
    if alt_click then
        updateHandler.execute({refresh = true})
        return
    end
    updateHandler.execute({
        preference = EnumRolePreference.NONE,
        search_text = "",
        sort_by = EnumDisplayBoardSort.DIFFICULTY,
        is_reverse = false
    })
end

function onChangeDisplayBoardPagePrev(_, _, alt_click)
    if alt_click then return end
    local displayBoard = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)
    local currPageNum = displayBoard.page_num
    local newPageNum = math.max(1, currPageNum - 1)
    updateHandler.execute({page_num = newPageNum})
end

function onChangeDisplayBoardPageNext(_, _, alt_click)
    if alt_click then return end
    local displayBoard = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)
    local currPageNum = displayBoard.page_num
    local newPageNum = math.min(currPageNum + 1, displayBoard.max_page_num)
    updateHandler.execute({page_num = newPageNum})
end

function onChangeDisplayBoardPageNum (_, _, input_value, stillEditing)
    if stillEditing then return end
    local displayBoard = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY)
    input_value = tonumber(input_value)
    if type(input_value) ~= "number" then
        editDisplayBoardInputPageNum(displayBoard.page_num)
        return
    end
    local newPageNum = math.max(1, math.min(math.floor(input_value), displayBoard.max_page_num))
    updateHandler.execute({page_num = newPageNum})
end

function onChangeDisplayBoardSettingSearchText(_, _, input_value, stillEditing)
    if stillEditing then return end
    updateHandler.execute({search_text = input_value, page_num = 1})
end

function onChangeDisplayBoardSettingPreference(_, _, alt_click)
    if alt_click then return end
    local valueList = {
            EnumRolePreference.NONE,
            EnumRolePreference.GATHERING,
            EnumRolePreference.HUNTING,
            EnumRolePreference.NO_PREFERENCE,
        }
    local currValue = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).preference
    local newValue = getNextValInValList(currValue, valueList)
    updateHandler.execute({preference = newValue, page_num = 1})
end

function onChangeDisplayBoardSettingSortBy(_, _, alt_click)
    if alt_click then return end
    local valueList = {EnumDisplayBoardSort.DIFFICULTY, EnumDisplayBoardSort.TIME}
    local currValue = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).sort_by
    local newValue = getNextValInValList(currValue, valueList)
    updateHandler.execute({sort_by = newValue, page_num = 1})
end

function onChangeDisplayBoardSettingIsReverse(_, _, alt_click)
    if alt_click then return end
    local valueList = {false, true}
    local currValue = GAME:getPublicItemManager():getBoardDisplay(NAME_BOARD_DISPLAY).is_reverse
    local newValue = getNextValInValList(currValue, valueList)
    updateHandler.execute({is_reverse = newValue, page_num = 1})
end
