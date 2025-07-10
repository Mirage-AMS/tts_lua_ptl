--[[
The Game is running based on button pressed.
In One's turn, the player press each phase button to pull the phase.
]]--
require("mock/default")
require("com/const")
require("com/basic")
require("src/game")

function getButtonIdx(name)
    return getValIdxInValList(name, DEFAULT_BUTTON_LIST)
end

local function discardCardLikeObject(obj)
    if not isCardLike(obj) then
        return false
    end

    local itemManager = GAME:getPublicItemManager()
    if not itemManager then
        error("fatal error: itemManager not found")
    end
    local tags = obj.getTags()
    if not tags or #tags == 0 then
        return false
    end

    for _, tag in ipairs(tags) do
        if isValInValList(tag, PUBLIC_ZONE_NAME_LIST) then
            local zone = itemManager:getZone(tag)
            if zone then
                zone:setObjDiscard(obj)
                return true
            end
        end
    end
    return false
end

local function clearPlayerDiscardZone(player_color)
    -- get rubbishBin
    local itemManager = GAME:getPublicItemManager()
    if not itemManager then
        error("fatal error: itemManager not found")
        return false
    end
    local rubbishBin = itemManager:getContainer(NAME_RUBBISH_BIN)

    -- clean discardZone
    local playerItemManager = GAME:getPrivateItemManager(player_color)
    if not playerItemManager then
        error("fatal error: playerItemManager not found")
        return false
    end
    local discardZone = playerItemManager:getZone(NAME_ZONE_DISCARD)

    if not discardZone then
        error("fatal error: discardZone not found")
        return false
    end
    local discardSlot = discardZone.discard_slot
    if not discardSlot then
        error("fatal error: discardZone discardSlot not found")
        return false
    end

    local objList = discardSlot:getCardObjects()
    if not objList or #objList == 0 then
        return true
    end

    for _, obj in ipairs(objList) do
        if not discardCardLikeObject(obj) then
            rubbishBin:putObject(obj)
        end
    end

    return true
end

function updateButtonState()
    -- quick break if currState not legal
    local turnManager = GAME:getTurnManager()
    local currState = turnManager:getState()
    if currState == nil then
        print("unexpected state")
        return
    end

    -- quick break if main board not found
    local itemManager = GAME:getPublicItemManager()
    local main_board = itemManager:getBoard(NAME_BOARD_MAIN)
    if not main_board then
        print("main board not found")
        return
    end

    -- quick break if button less than expect
    local buttonList = main_board:getButtons()
    if not buttonList or #buttonList < #DEFAULT_BUTTON_LIST then
        print("button less than expect")
        return
    end

    -- update button color
    for i, _ in ipairs(DEFAULT_BUTTON_LIST) do
        local objColor = (currState >= i) and {0.5, 0.5, 0.5, 0.8} or {1, 1, 1, 1}
        local param = {index = i - 1, color = objColor}
        main_board:editButton(param)
    end
end

local function trigBeggingPhaseEffect(player_clicker_color,_)
    -- fill zone display slots
    local publicItemManager = GAME:getPublicItemManager()
    for _, zoneName in ipairs(PUBLIC_ZONE_NAME_LIST) do
        local zone = publicItemManager:getZone(zoneName)
        if zone then
            if zoneName == NAME_ZONE_MARKET then
                zone:fillDisplaySlots(nil, true)
            else
                zone:fillDisplaySlots(nil, false)
            end
        end
    end

    -- reset turn player's zone
    local playerItemManager = GAME:getPrivateItemManager(player_clicker_color)
    local zonesToProcess = {
        {name = NAME_ZONE_ELEMENT, action = function(deckSlot) deckSlot:setFlipped(false) end},
        {name = NAME_ZONE_BACKPACK, action = function(deckSlot) deckSlot:setStraight() end},
        {name = NAME_ZONE_ABILITY, action = function(deckSlot) deckSlot:setStraight() end}
    }
    for _, zoneInfo in ipairs(zonesToProcess) do
        local zone = playerItemManager:getZone(zoneInfo.name)
        if zone then
            local deckSlot = zone.deck_slot
            if deckSlot then
                zoneInfo.action(deckSlot)
            else
                print("fatal error: deckSlot not found in " .. zoneInfo.name)
            end
        end
    end
    ---- reset all wounds
    local roleBoard = playerItemManager:getBoard(NAME_BOARD_ROLE)
    if roleBoard then
        local idxHp = 1
        local idxWound = 5
        local valueHp = roleBoard:getValueByIndex(idxHp)
        local valueWound = roleBoard:getValueByIndex(idxWound)
        if not valueHp or not valueWound or valueWound >= valueHp then
            return
        end
        roleBoard:tiltValueByIndex(idxWound, -valueWound)
    end
end

local function trigDrawPhaseEffect(player_clicker_color, alt)
    if alt then return end
    -- deal 1 card to hand
    local itemManager = GAME:getPublicItemManager()
    local conventicleZone = itemManager:getZone(NAME_ZONE_CONVENTICLE)
    if conventicleZone then
        conventicleZone:dealDeckCardIntoHand(1, player_clicker_color)
    end
end

local function trigEndPhaseEffect(player_clicker_color, _)
    local turnManager = GAME:getTurnManager()
    local playerService = GAME:getPlayerService()

    -- discard cards
    clearPlayerDiscardZone(player_clicker_color)

    -- pass turn
    local seatedPlayerNum = playerService:getSeatedPlayerNum()
    local playerInstance = playerService:getPlayerObject(player_clicker_color)
    if seatedPlayerNum ~= 1 then
        turnManager:setTurnColor(turnManager:getNextTurnColor())
    else
        -- manually trigger onPlayerTurn
        onPlayerTurn(playerInstance, playerInstance)
    end
end

function trigButtonStateEffect(alt_click)

    local turnManager = GAME:getTurnManager()
    local currState = turnManager:getState()
    local trigReflect = {
        nil,                        -- 1 = init game
        nil,                        -- 2 = claim first
        trigBeggingPhaseEffect,     -- 3 = begin phase
        trigDrawPhaseEffect,        -- 4 = draw phase
        nil,                        -- 5 = standby phase
        nil,                        -- 6 = action phase
        trigEndPhaseEffect,         -- 7 = end phase
    }

    if trigReflect[currState] then
        trigReflect[currState](turnManager:getCurrentPlayer(), alt_click)
    end
end

function onButtonClickChangeState(obj, player_clicker_color, alt_click, target_state)
    -- manager
    local turnManager = GAME:getTurnManager()

    -- quick break if not trigger
    if turnManager:getCurrentPlayer() ~= player_clicker_color then
        broadcastToColor("只有当前回合玩家才能改变回合阶段", player_clicker_color)
        return
    end

    -- quick break if state drawback
    local currState = turnManager:getState()
    if currState == nil then
        print("unexpected state")
        return
    end
    if target_state < currState then
        broadcastToAll("你不能回到上个阶段", player_clicker_color)
        return
    end

    -- push state
    for idx = currState + 1, target_state do
        -- update state
        turnManager:setState(idx)
        updateButtonState()
        ---- trigger effect
        trigButtonStateEffect(alt_click)
    end
end

function onButtonClickInitGame(_, player_clicker_color, alt_click)
    -- quick break
    if alt_click then return end

    -- quick break if game mode is not set yet
    local publicService = GAME:getPublicService()
    if not publicService:isGameModeSet() then
        broadcastToColor("请先在游戏面板确认游戏模式", player_clicker_color)

        local gameBoard = publicService:getPublicBoard(NAME_BOARD_GAME)
        if not gameBoard then
            error("fatal error: could not find game board")
        end

        -- ping table to hint
        local pingPos = gameBoard:getPosition()
        local playerService = GAME:getPlayerService()
        playerService:letPlayerPingTable(player_clicker_color, pingPos)
        return
    end

    -- quick break if game has started
    local turnManager = GAME:getTurnManager()
    local currState = turnManager:getState()

    if currState >= 1 then
        broadcastToColor("已经开局, 请勿重复操作", player_clicker_color)
        return
    end

    ---- update turn state
    turnManager:setState(1)
    updateButtonState()

    ---- shuffle all decks
    local itemManager = GAME:getPublicItemManager()
    for _, zoneName in ipairs(PUBLIC_ZONE_NAME_LIST) do
        local zone = itemManager:getZone(zoneName)
        if zone then
            zone:shuffleDeck()
        else
            print("error: could not find zone " .. zoneName)
        end
    end

    ---- deal initial hand
    local dealNum = 5
    local playerService = GAME:getPlayerService()
    local playerList = playerService:getSeatedPlayerColorList()
    local conventicleZone = itemManager:getZone(NAME_ZONE_CONVENTICLE)
    if conventicleZone then
        for _, player_color in ipairs(playerList) do
            conventicleZone:dealDeckCardIntoHand(dealNum, player_color)
        end
    end
end

function onButtonClickClaimFirst(_, player_clicker_color, alt_click)
    -- quick break
    if alt_click then return end

    -- quick break if not default player
    local playerService = GAME:getPlayerService()
    if not playerService:isPlayerDefault(player_clicker_color) then
        broadcastToAll("只有坐下的玩家可以认先")
        return
    end

    -- quick break if game has started
    local turnManager = GAME:getTurnManager()
    if turnManager:isGameStart() then
        if turnManager:isTurnEnable() then
            broadcastToColor("已经开局, 请勿重复操作", player_clicker_color)
        else
            -- if claim first is clicked, turn must be enabled
            -- if not, regard it as loading a saved game
            broadcastToAll("加载存档，重新开局")
            turnManager:setTurnColor(turnManager:getCurrentPlayer())
            turnManager:setTurnEnable(true)
        end
        return
    end

    -- turn setup
    broadcastToAll(player_clicker_color.." 玩家先手", player_clicker_color)
    turnManager:setFirstPlayer(player_clicker_color)
    turnManager:setTurnColor(player_clicker_color)
    turnManager:setTurnEnable(true)

    ---- shuffle all conventicle cards back
    local itemManager = GAME:getPublicItemManager()
    local conventicleZone = itemManager:getZone(NAME_ZONE_CONVENTICLE)
    if conventicleZone then
        conventicleZone:getRebuildDeckObj()
    end
end

function onButtonClickBeginningPhase(obj, player_clicker_color, alt_click)
    onButtonClickChangeState(obj, player_clicker_color, alt_click, getButtonIdx(NAME_BUTTON_BEGINNING_PHASE))
end

function onButtonClickDrawPhase(obj, player_clicker_color, alt_click)
    onButtonClickChangeState(obj, player_clicker_color, alt_click, getButtonIdx(NAME_BUTTON_DRAW_PHASE))
end

function onButtonClickStandbyPhase(obj, player_clicker_color, alt_click)
    onButtonClickChangeState(obj, player_clicker_color, alt_click, getButtonIdx(NAME_BUTTON_STANDBY_PHASE))
end

function onButtonClickActionPhase(obj, player_clicker_color, alt_click)
    onButtonClickChangeState(obj, player_clicker_color, alt_click, getButtonIdx(NAME_BUTTON_ACTION_PHASE))
end

function onButtonClickEndPhase(obj, player_clicker_color, alt_click)
    onButtonClickChangeState(obj, player_clicker_color, alt_click, getButtonIdx(NAME_BUTTON_END_PHASE))
end

function onButtonClickShowThreeCard()
    local itemManager = GAME:getPublicItemManager()
    local conventicleZone = itemManager:getZone(NAME_ZONE_CONVENTICLE)
    if not conventicleZone then
        print("fatal error: could not find zone " .. NAME_ZONE_CONVENTICLE)
        return
    end
    conventicleZone:fillTopSlots(nil, true)
end