require("com/const")

function isDeck(object)
    if object == nil then return false end
    return object.type == DEFAULT_TYPE_DECK
end

function isCard(object)
    if object == nil then return false end
    return object.type == DEFAULT_TYPE_CARD
end

function isTile(object)
    if object == nil then return false end
    return object.type == DEFAULT_TYPE_TILE
end

function isScripting(object)
    if object == nil then return false end
    return object.type == DEFAULT_TYPE_SCRIPTING
end

function isCardLike(object)
    return isCard(object) or isDeck(object)
end

function isCardLegal(obj, tag)
    if not isCardLike(obj) then return false end
    if tag and not obj.hasTag(tag) then return false end
    return true
end

function isTokenLike(object)
    return isTile(object) and object.hasTag(DEFAULT_TAG_TOKEN)
end
