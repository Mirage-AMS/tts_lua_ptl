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

--- setupRoleCard: Set up the role cards in the game.
function setupRoleCard()
    local boardPattern = ROLE_DISPLAY_BOARD_PATTERN

    local dx, dz = boardPattern.dx, boardPattern.dz
    local dxx, dzz = boardPattern.dxx, boardPattern.dzz
    local dxxx, dzzz = boardPattern.dxxx, boardPattern.dzzz

    local publicService = GAME:getPublicService()
    local displayBoardPosList = {}
    for idx, eachBoardName in ipairs(BOARD_ROLE_DISPLAY_LIST) do
        local eachBoard = publicService:getPublicBoard(eachBoardName)
        if not eachBoard then
            error("fatal error: publicService:getPublicBoard(\"" .. eachBoardName .. "\") is nil")
        end
        displayBoardPosList[idx] = eachBoard:getPosition() + boardPattern.origin
    end


    local locDataDict = LIST_PARAM_ROLE_DISPLAY
    for prefix, eachDeckDataList in pairs(locDataDict) do
        local eachDeck = publicService:getDevDeck(prefix)
        if not isCardLike(eachDeck) then
            error("fatal error: getDevDeck[" .. prefix .. "] is nil")
        end

        -- clone deck from dev deck
        local _clonedShift = Vector(0, 2, 0)
        local eachDeckPos = eachDeck.getPosition()
        local eachClonedDeck = eachDeck.clone({position = eachDeckPos + _clonedShift})

        -- take object and put
        for _, cardData in ipairs(eachDeckDataList) do
            local offsets = {
                [1] = { x = cardData.idx or 1, z = cardData.idz or 1, dx = dx, dz = dz },
                [2] = { x = cardData.idxx or 1, z = cardData.idzz or 1, dx = dxx, dz = dzz },
                [3] = { x = cardData.idxxx or 1, z = cardData.idzzz or 1, dx = dxxx, dz = dzzz }
            }

            --- 3 times pattern shift
            local pos = displayBoardPosList[cardData.id]
            for index, offset in ipairs(offsets) do
                pos = getOffsetPosition(pos, offset.x, offset.z, offset.dx, offset.dz)
                -- special case for 3rd pattern shift, shift up a little bit
                if index == 3 and offset.x > 1 then
                    pos = pos + Vector(0, 0.05, 0) * (offset.x - 1)
                end
            end

            eachClonedDeck.takeObject({position = pos, flip=true}).setLock(true)
        end
    end

end

--- setDevBoardHidden: Hide the development board and all its components.
function setDevBoardHidden()
    local hideId = "DevBoardHider"
    local publicService = GAME:getPublicService()
    local playerList = DEFAULT_ALL_COLOR_LIST

    --- hide dev board
    local devBoardName = NAME_BOARD_DEVELOPMENT
    local devBoard = publicService:getPublicBoard(devBoardName)
    if not devBoard.object then
        error("fatal error: devBoard.object is nil")
    end
    devBoard.object.attachInvisibleHider(hideId, true, playerList)

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
        eachDeck.attachInvisibleHider(hideId, true, playerList)
    end
end