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

--- setDevBoardHidden: Hide the development board and all its components.
function setDevBoardHidden()
    local hideId = "DevBoardHider"
    local publicService = GAME:getPublicService()

    --- hide dev board
    local devBoardName = NAME_BOARD_DEVELOPMENT
    local devBoard = publicService:getPublicBoard(devBoardName)
    if not devBoard.object then
        error("fatal error: devBoard.object is nil")
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