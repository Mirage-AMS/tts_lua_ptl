require("com/object_type")

---mergeCard: merge two cards together
---@param obj1 Object? object to merge into
---@param obj2 Object? object to merge
---@param tag? string optional tag to use for merging
---@return Object? result merged object
function mergeCard(obj1, obj2, tag)
    if not isCardLegal(obj1, tag) and not isCardLegal(obj2, tag) then
        return nil
    end

    if not isCardLegal(obj1, tag) and isCardLegal(obj2, tag) then
        return obj2
    end

    if isCardLegal(obj1, tag) and not isCardLegal(obj2, tag) then
        return obj1
    end

    ---@cast obj1 Object
    ---@cast obj2 Object
    return obj1.putObject(obj2)
end

---dealCard: deal a card to a location
---@param obj Object object to deal a card from
---@param location table location to deal card
---@param flip boolean whether or not to flip the card
---@return boolean result whether or not the card was dealt
function dealCard(obj, location, flip)
    -- flip defaults to true if not provided
    if flip == nil then
        flip = false
    end

    -- quick error break
    if obj == nil or not isCardLike(obj) then
        return false
    end

    -- normal
    local isFlip = obj.is_face_down == flip
    if isDeck(obj) then
        obj.takeObject({position=location, flip=isFlip})
    else
        if isFlip then
            obj.flip()
        end
        -- setPositionSmooth(position, collide, fast)
        obj.setPositionSmooth(location, false, true)
    end
    return true
end

---numCard: get how many cards are in an object
---@param obj Object object to check for card count
---@return number result number of cards in object
function numCard(obj)
    -- quick error break
    if obj == nil then return 0 end
    -- normal
    if isCard(obj) then
        return 1
    elseif isDeck(obj) then
        return #obj.getObjects()
    else
        return 0
    end
end


--- registerCard: generate all deck items and register info on them
--- @param deck any: The deck to register.
--- @param info table|nil: The information about the deck.
--- @return nil
function registerCard(deck, info)
    -- quick break if not legal deck object
    if deck == nil then
        error("fatal error: a nil deck object was passed to register")
    end
    if not isCardLike(deck) then
        error("fatal error: a non-card object was passed to register")
    end
    local cardNum = numCard(deck)
    if info and #info ~= cardNum then
        error("fatal error: info table length "..#info.." does not match card number " .. cardNum)
    end

    -- register the deck
    deck.setLock(true)
    local cardSet = {}
    local _initShift = 1.5
    local _eachShift = 0.5
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