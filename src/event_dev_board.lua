require("com/const")
require("com/enum_const")
require("com/const_dev_board")
require("com/object_type")
require("src/card")

-- registerDeckInfo: Register deck information for the game.
function registerDeckInfo()

    local devZoneName = NAME_ZONE_DEVELOPMENT
    local publicService = GAME:getPublicService()
    local publicItemManager = GAME:getPublicItemManager()
    if not publicItemManager then
        error("fatal error: publicItemManager is nil")
    end
    local devZone = publicItemManager:getZone(devZoneName)
    if not devZone then
        error("fatal error: devZone is nil")
    end
    local devZoneDisplaySlots= devZone.display_slots
    if not devZoneDisplaySlots then
        error("fatal error: devZoneDisplaySlots is nil")
    end

    -- var init
    local all_deck_list = DECK_LIST
    local all_infos = DECK_INFO

    for _, prefix in ipairs(all_deck_list) do
        -- deck
        local eachDeck = publicService:getDevDeck(prefix)
        if not isCardLike(eachDeck) then
            error("fatal error: getDevDeck[" .. prefix .. "] is nil")
        end

        -- info
        local eachInfo = {}
        local eachDeckInfo = all_infos[prefix]
        for idx = 1, #eachDeckInfo do
            local eachCardInfo = {
                name = eachDeckInfo[idx],
                memo = prefix .. "_" .. string.format("%02d", idx)
            }
            table.insert(eachInfo, eachCardInfo)
        end

        registerCard(eachDeck, eachInfo)
    end
end

--- checkDeckInfo: Re-Check the information of development decks after the game starts.
function checkDeckInfo()
    ---@type string[]
    local all_deck_list = DECK_LIST
    ---@type table<string, string[]>
    local all_deck_info = DECK_INFO

    local publicService = GAME:getPublicService()

    for _, prefix in ipairs(all_deck_list) do
        local eachDeck = publicService:getDevDeck(prefix)
        local eachDeckInfo = all_deck_info[prefix]
        if eachDeckInfo == nil or #eachDeckInfo <= 0 then
            error("fatal error: devDeck[" .. prefix .. "] info is nil")
        end
        if eachDeck == nil or not isCardLike(eachDeck) then
            error("fatal error: getDevDeck[" .. prefix .. "] is nil")
        end
        local eachDeckGetObjects = eachDeck.getObjects()

        --- check count
        if #eachDeckGetObjects ~= #eachDeckInfo then
            error("fatal error: devDeck[" .. prefix .. "] card count mismatch" .. #eachDeckGetObjects .. " != " .. #eachDeckInfo)
        end

        --- check specific card
        for idx, eachCard in ipairs(eachDeckGetObjects) do
            if eachCard.name ~= eachDeckInfo[idx] then
                print("warning: devDeck[" .. prefix .. "] card name mismatch" .. eachCard.name .. " != " .. eachDeckInfo[idx])
            end
        end
    end
end

--- setDevBoardHidden: Hide the development board and all its components.
function setDevBoardHidden()
    local hideId = "DevBoardHider"
    local publicService = GAME:getPublicService()

    --- hide dev board
    local devBoardName = NAME_BOARD_DEVELOPMENT
    local devBoard = publicService:getPublicBoard(devBoardName)
    if not devBoard or not devBoard.object then
        error("fatal error: devBoard not found")
    end
    devBoard.object.attachInvisibleHider(hideId, true, DEFAULT_ALL_COLOR_LIST)

    --- hide dev zone's cards
    local devZoneName = NAME_ZONE_DEVELOPMENT
    local devZone = publicService:getPublicZone(devZoneName)
    if not devZone then
        error("fatal error: devZone is nil")
    end
    local devZoneDisplaySlots= devZone.display_slots
    if not devZoneDisplaySlots then
        error("fatal error: devZoneDisplaySlots is nil")
    end
    local all_deck_list = DECK_LIST
    for _, prefix in ipairs(all_deck_list) do
        -- deck
        local eachDeck = publicService:getDevDeck(prefix)
        if not eachDeck then
            error("fatal error: getDevDeck[" .. prefix .. "] is nil")
        end
        eachDeck.attachInvisibleHider(hideId, true, DEFAULT_ALL_COLOR_LIST)
    end
end


--- setupContainer: Set up the container for development cards.
function setupContainer()
    ---@type table<string, {origin: number, prefix: string, index: number, flip?: boolean}>
    local registerContainerInfo = CONTAINER_REGISTER_DICT
    local publicService = GAME:getPublicService()
    local publicItemManager = GAME:getPublicItemManager()

    for key, info in pairs(registerContainerInfo) do
        --- init
        local targetContainer = publicItemManager:getContainer(key)
        if not targetContainer then
            error("fatal error: container[" .. key .. "] is nil")
        end
        local pos = targetContainer:getPosition()
        local origin = info.origin
        local prefix = info.prefix
        local takeItem

        --- take item
        if origin == EnumItemOrigin.DEV_DECK then
            local deckIdx = info.index
            local devDeck = publicService:getDevDeck(prefix)
            if not devDeck then
                error("fatal error: devDeck[" .. prefix .. "] is nil")
            end
            local isFlip = true
            if info.flip ~= nil then isFlip = info.flip end
            local rot = isFlip and __CARD_ROTATION_FACE_UP or __CARD_ROTATION_FACE_DOWN
            local pos = pos + Vector(0, 5, 0)
            local clonedDeck = devDeck.clone({position = pos})
            local takeParam = {index = deckIdx - 1, position = pos, rotation = rot}
            takeItem = clonedDeck.takeObject(takeParam)
            clonedDeck.destruct()
        end
    end
end
