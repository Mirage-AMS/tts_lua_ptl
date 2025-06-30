require("com/object_type")
function mergeCard(obj1, obj2, tag)
    -- Merges obj2 into obj1
    -- param: [obj] ojb1: card to merge into
    -- param: [obj] obj2: card to merge
    -- param: [str] tag: optional tag to use for merging
    -- Returns: [obj] merged deck
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