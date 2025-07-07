require("com/enum_const")
require("com/deck_const")
require("com/object_type")

--- registerDeck: generate all deck items and register info on them
--- @param deck any: The deck to register.
--- @param info table|nil: The information about the deck.
--- @return nil
local function registerDeck(deck, info)
    -- quick break if not legal deck object
    if deck == nil then
        error("fatal error: a nil deck object was passed to register")
    end
    if not isCardLike(deck) then
        error("fatal error: a non-card object was passed to register")
    end
    local cardNum = numCard(deck)
    if info and #info ~= cardNum then
        error("fatal error: info table length does not match card number")
    end

    -- register the deck
    deck.setLock(true)
    local cardSet = {}
    local _initShift = 1.75
    local _eachShift = 0.2
    local pos = deck.getPosition()
    pos.y = pos.y + _initShift + _eachShift * cardNum

    -- closure to create a callback function for each card
    local function createCallback(idx)
        return function(spawnedObject)
            cardSet[idx] = spawnedObject
            spawnedObject.setLock(true)
            if info then
                local cardInfo = info[idx]
                spawnedObject.setName(cardInfo.name)
                spawnedObject.memo = cardInfo.memo
            end
        end
    end

    -- 生成卡牌
    for idx = 1, cardNum do
        deck.takeObject({
            position = pos,
            callback_function = createCallback(idx)  -- 传递信息而非索引
        })
        pos.y = pos.y - _eachShift
    end

    Wait.condition(
    function()
        for _, eachCard in ipairs(cardSet) do
            eachCard.setLock(false)
        end
        end,
    function()
        return #cardSet == cardNum
    end,
    2,
    function()
        error("fatal error: card set size does not match expected number of cards: "..tostring(#cardSet))
    end)
end

--- initDevelopmentMode: Initializes the game in development mode.
--- @return nil
local function initDevelopmentMode()
    -- TODO implement development mode initialization
    broadcastToAll("Development Mode Enabled")
    GAME.public_service:setMode(GameMode.Development)
end


--- cleanDevelopmentMode: Cleans up the game when switching out of development mode.
--- @return nil
local function cleanDevelopmentMode()
    -- TODO implement development mode cleanup
    broadcastToAll("Development Mode Disabled")

    -- ONLY FOR FUNCTION TESTING
    local info = {}
    local CO_STD_MAPPING = {
        [1] = { prefix = "CO_STD01_", data = CO_STD_01 },
        [2] = { prefix = "CO_STD02_", data = CO_STD_02 }
    }

    -- 循环生成信息
    for idx = 1, 60 do
        local idxMapped = ((idx - 1) % 30) + 1
        local group = math.floor((idx - 1) / 30) + 1
        local config = CO_STD_MAPPING[group]
        if not config then
            error("fatal error: no config found for group " .. tostring(group))
        end
        table.insert(info, {
            name = config.data[idxMapped],
            memo = config.prefix .. string.format("%02d", idxMapped)
        })
    end

    local publicItemManager = GAME:getPublicItemManager()
    local coventicleZone = publicItemManager:getZone(NAME_ZONE_CONVENTICLE)
    local conventicleDeck = coventicleZone:getDeckObj()
    registerDeck(conventicleDeck, info)

    GAME.public_service:setMode(GameMode.Guest)
end

--- SwitchDevMode: for ContextMenu switching development mode on and off.
---@return nil
function SwitchDevMode()
    if GAME:isDevelopmentMode() then
        cleanDevelopmentMode()
    else
        initDevelopmentMode()
    end
end
