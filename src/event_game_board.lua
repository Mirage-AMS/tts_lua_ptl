require("mock/default")
require("com/const")
require("com/basic")
require("com/enum_const")
require("com/const_game_board")
require("src/event_dev_board")

--- isGameModeSetable: Check if player can set game mode
--- @return boolean
local function isGameModeSetable()
    local publicService = GAME:getPublicService()

    -- game-mode can't be set in dev-mode
    if publicService:isDevMode() then
        broadcastToAll("Dev-Mode is enabled, please disable it first")
        return false
    end

    -- game-mode can't be set if it is already set
    if publicService:isGameModeSet() then
        broadcastToAll("Game mode is already set")
        return false
    end

    return true
end


--- setDeckPosition: Set the position of each deck in the game.
--- @param zoneReflect table<string, string[]>
local function setDeckPosition(zoneReflect)
    local publicService = GAME:getPublicService()

    for zoneName, deckList in pairs(zoneReflect) do
        -- get target position
        local zone = publicService:getPublicZone(zoneName)
        if not zone then
            error("fatal error: publicItemManager:getZone(\"" .. zoneName .. "\") is nil")
        end
        local deckSlot = zone.deck_slot
        if not deckSlot then
            error("fatal error: "..zoneName..".deck_slot is nil")
        end
        local pos = deckSlot:getPosition()
        if not pos then
            error("fatal error: "..zoneName..".deck_slot.getPosition() is nil")
        end
        local _initShift = 2.0
        local _eachShift = 1.0
        pos.y = pos.y + _initShift

        for _, prefix in ipairs(deckList) do
            -- get origin deck
            local eachDeck = publicService:getDevDeck(prefix)
            if not eachDeck or not isCardLike(eachDeck) then
                error("fatal error: getDevDeck[" .. prefix .. "] is nil")
            end
            eachDeck.clone({position = pos})
            pos.y = pos.y + _eachShift
        end
    end
end


--- update game goal
---@param gameGoal number
local function updateGameGoal(gameGoal)
    local publicService = GAME:getPublicService()
    local gameBoard = publicService:getPublicBoard(NAME_BOARD_GAME)
    if not gameBoard then
        error("fatal error: publicService:getPublicBoard(\"" .. gameBoard .. "\") is nil")
    end

    -- clean up
    local legendZone = publicService:getPublicZone(NAME_ZONE_LEGEND_DISPLAY)
    if not legendZone then
        error("fatal error: publicService:getPublicZone(\"" .. legendZone .. "\") is nil")
    end
    local legendDeckSlot = legendZone.deck_slot
    if not legendDeckSlot then
        error("fatal error: "..legendZone.name..".deck_slot is nil")
    end
    for _, card in ipairs(legendDeckSlot:getCardObjects()) do
        card.destruct()
    end

    -- setup legend card
    local prefix = PREFIX_LG_STD01
    local boardPattern = GAME_BOARD_PATTERN
    local dx, dz = GAME_BOARD_PATTERN.dx, GAME_BOARD_PATTERN.dz
    local pos = gameBoard:getPosition() + boardPattern.origin

    local deck = publicService:getDevDeck(prefix)
    if not deck or not isCardLike(deck) then
        error("fatal error: getDevDeck[" .. prefix .. "] is nil")
    end

    local dataList = LIST_PARAM_LEGEND_DISPLAY[gameGoal]
    for _, locData in ipairs(dataList) do
        local deckIdx = locData.index
        local idx, idz = locData.idx, locData.idz
        local eachPos = getOffsetPosition(pos, idx, idz, dx, dz)
        local eachRot = __CARD_ROTATION_FACE_UP
        local clonedDeck = deck.clone({position = eachPos, rotation = eachRot})
        local takeParam = {index = deckIdx - 1, position = eachPos, rotation = eachRot}
        clonedDeck.takeObject(takeParam).setLock(true)
        clonedDeck.destruct()
    end

end

--- update game deck set
---@param deckSet number
local function updateDeckSet(deckSet)
    -- clean up
    local publicService = GAME:getPublicService()
    for _, zoneName in ipairs(PUBLIC_ZONE_NAME_LIST) do
        local zone = publicService:getPublicZone(zoneName)
        if not zone then
            error("fatal error: publicService:getPublicZone(\"" .. zoneName .. "\") is nil")
        end
        zone:destructDeck()
    end

    -- set new deck set
    if not EnumDeckSet(deckSet) then
        error("fatal error: not recognize deckSet: " .. tostring(deckSet))
    end
    local zoneReflect = {
        [NAME_ZONE_MOUNTAIN] = {PREFIX_MO_STD01, },
        [NAME_ZONE_FOREST] = {PREFIX_FO_STD01, },
        [NAME_ZONE_DUNGEON] = {PREFIX_DU_STD01, },
    }
    if deckSet == EnumDeckSet.STD then
        zoneReflect[NAME_ZONE_CONVENTICLE] = {PREFIX_CO_STD02, PREFIX_CO_STD01,}
        zoneReflect[NAME_ZONE_MARKET] = {PREFIX_MA_STD01,}
    elseif deckSet == EnumDeckSet.DLC01 then
        zoneReflect[NAME_ZONE_CONVENTICLE] = {PREFIX_CO_DLC01, PREFIX_CO_STD02, PREFIX_CO_STD01,}
        zoneReflect[NAME_ZONE_MARKET] = {PREFIX_MA_DLC01, PREFIX_MA_STD01,}
    end

    setDeckPosition(zoneReflect)
end

-- update enable role
---@param enableRole boolean
local function updateEnableRole(enableRole)
    -- clean up
    local zoneName = NAME_ZONE_ROLE_PICK
    local rolePickZone = GAME:getPublicService():getPublicZone(zoneName)
    if not rolePickZone then
        error("fatal error: role pick zone is nil")
    end
    rolePickZone:destructDeck()
    -- set new deck set
    if enableRole then
        local zoneReflect = {
            [NAME_ZONE_ROLE_PICK] = {PREFIX_RO_INT02, PREFIX_RO_INT01}
        }
        setDeckPosition(zoneReflect)
    end
end

--- update game mode
---@param data table<string, any>: data to update
---@param forceUpdate boolean: force update all fields
function updateGameMode(data, forceUpdate)
    local paramDictAll = PARAM_GAME_BOARD_SWITCH_BUTTON_CHANGE
    local publicService = GAME:getPublicService()
    local gameModeManager = publicService:getGameModeManager()
    local gameBoard = publicService:getPublicBoard(NAME_BOARD_GAME)
    if not gameBoard then
        error("fatal error: gameBoard is nil")
    end

    -- 定义设置项与处理函数的映射，同时指定在paramDictAll中的索引位置
    local settingsMap = {
        { key = "game_goal",    handler = updateGameGoal },
        { key = "deck_set",     handler = updateDeckSet },
        { key = "enable_role",  handler = updateEnableRole },
        { key = "bp_strategy",  handler = nil },
    }
    local isSet = publicService:isGameModeSet()
    if isSet then
        gameBoard:editButton({index=0, color=__BUTTON_COLOR_DISABLE})
    end

    for index, setting in ipairs(settingsMap) do
        local key = setting.key
        local toRunFunc = setting.handler

        local currValue = gameModeManager[key]
        local newValue = data[key]
        if forceUpdate then newValue = currValue end

        if newValue ~= nil and (forceUpdate or currValue ~= newValue) then
            -- update game mode manager
            gameModeManager[key] = newValue

            --- this will result update
            if not isSet and toRunFunc ~= nil then
                toRunFunc(newValue)
            end

            -- update button info
            if paramDictAll[index] == nil then
                error("Missing paramDict for setting: " .. key)
            end
            local paramDict = paramDictAll[index]
            if type(paramDict) ~= "table" then
                error("paramDict is not a table")
            end
            local param = paramDict[newValue]
            if type(param) ~= "table" then
                error("param is not a table")
            end
            param.index = index
            param.color = isSet and __BUTTON_COLOR_DISABLE or param.color
            gameBoard:editButton(param)
        end
    end
end

--- a wrapper function to toggle between values
---@param valueType string: type of value to switch
---@param valueList table: value to switch between
---@param getCurrentValue function: callable func to get current value
---@param debounceTime? number: time to wait before allowing another click (in milliseconds)
local function onButtonClickToggle(valueType, valueList, getCurrentValue, debounceTime)
    -- use a closure to realize debounce
    debounceTime = debounceTime or 500 -- default debounce time is 200ms
    local lastClickTime = 0.0

    return function()
        local currentTime = Time.time * 1000 -- convert to milliseconds

        -- quick break if debounce time is not passed
        if currentTime - lastClickTime < debounceTime then return end

        lastClickTime = currentTime

        -- quick break if game mode is not setable
        if not isGameModeSetable() then return end

        local currentValue = getCurrentValue()
        local newValue = getNextValInValList(currentValue, valueList)
        updateGameMode({[valueType] = newValue}, false) -- 传递类型和新值
    end
end

onButtonClickSwitchGameGoal = onButtonClickToggle(
    "game_goal",
    {EnumGameGoal.QUICK, EnumGameGoal.STANDARD},
    function() return GAME:getPublicService():getGameModeManager().game_goal end
)

onButtonClickSwitchDeckSet = onButtonClickToggle(
    "deck_set",
    {EnumDeckSet.STD, EnumDeckSet.DLC01},
    function() return GAME:getPublicService():getGameModeManager().deck_set end
)

onButtonClickSwitchRole = onButtonClickToggle(
    "enable_role",
    {false, true},
    function() return GAME:getPublicService():getGameModeManager().enable_role end
)

onButtonClickSwitchBpStrategy = onButtonClickToggle(
    "bp_strategy",
    { EnumBPStrategy.FREE, EnumBPStrategy.STANDARD},
    function() return GAME:getPublicService():getGameModeManager().bp_strategy end
)

local function applyBPStrategyStandard()
    local rolePickZone = GAME:getPublicService():getPublicZone(NAME_ZONE_ROLE_PICK)
    if not rolePickZone then
        error("fatal error: could not find role pick zone")
    end
    -- shuffle role pick deck
    rolePickZone:shuffleDeck()

    -- deal role pick cards
    local dealNum = 5
    local playerService = GAME:getPlayerService()
    local playerList = playerService:getSeatedPlayerColorList()
    for _, player_color in ipairs(playerList) do
        rolePickZone:dealDeckCardIntoHand(dealNum, player_color)
    end
    Wait.time(
        function()
            rolePickZone:destructDeck()
        end,
        1
    )
end

function onButtonClickSetGameModeFinished(_, _, _)
    local publicService = GAME:getPublicService()
    local gameModeManager = publicService:getGameModeManager()

    -- quick break if game mode is not setable
    if not isGameModeSetable() then return end

    -- set game mode finished
    publicService:getGameModeManager():setIsSet(true)
    updateGameMode({}, true)

    -- trigger game mode set event
    local enable_role = gameModeManager.enable_role
    local bp_strategy = gameModeManager.bp_strategy
    if enable_role and bp_strategy == EnumBPStrategy.STANDARD then
        applyBPStrategyStandard()
    end
end