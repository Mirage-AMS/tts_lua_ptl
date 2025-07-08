require("com/object_type")

---mergeCard: merge two cards together
---@param obj1 any object to merge into
---@param obj2 any object to merge
---@param tag string optional tag to use for merging
---@return any result merged object
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

    return obj1.putObject(obj2)
end

---dealCard: deal a card to a location
---@param obj any object to deal a card from
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
    if isDeck(obj) then
        obj.takeObject({position=location, flip=flip})
    else
        if obj.is_face_down ~= flip then
            obj.flip()
        end
        -- setPositionSmooth(position, collide, fast)
        obj.setPositionSmooth(location, false, true)
    end
    return true
end

---numCard: get how many cards are in an object
---@param obj any object to check for card count
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