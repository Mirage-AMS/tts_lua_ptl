require("com/const")
require("com/enum_const")
require("com/const_dev_board")
require("com/object_type")
require("src/card")

-- registerDeckInfo: Register deck information for the game.
local function registerDeckInfo()
    print("Enter registerDeckInfo")

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


--- setupNormalDeck: Sets up the normal deck for the game.
--- @param dlc_enable boolean: Enable or disable DLC content.
local function setupNormalDeck(dlc_enable)
    local zoneReflect = {
        [NAME_ZONE_MOUNTAIN] = {PREFIX_MO_STD01, },
        [NAME_ZONE_FOREST] = {PREFIX_FO_STD01, },
        [NAME_ZONE_DUNGEON] = {PREFIX_DU_STD01, },
        [NAME_ZONE_MARKET] = {PREFIX_MA_STD01, },
        [NAME_ZONE_CONVENTICLE] = {PREFIX_CO_STD02, PREFIX_CO_STD01,},
        [NAME_ZONE_ROLE_PICK] = {PREFIX_RO_INT02, PREFIX_RO_INT01,}
    }
    -- dlc enabled
    if dlc_enable then
        table.insert(zoneReflect[NAME_ZONE_MARKET], PREFIX_MA_DLC01)
        table.insert(zoneReflect[NAME_ZONE_CONVENTICLE], PREFIX_CO_DLC01)
    end

    -- logic start here ----------------------------------------------------------
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
        local _initShift = 2.0
        local _eachShift = 1.0
        pos.y = pos.y + _initShift

        for _, prefix in ipairs(deckList) do
            -- get origin deck
            local eachDeck = publicService:getDevDeck(prefix)
            if not isCardLike(eachDeck) then
                error("fatal error: getDevDeck[" .. prefix .. "] is nil")
            end
            eachDeck.clone({position = pos})
            pos.y = pos.y + _eachShift
        end
    end
end


local function setupLegendCard()
    -- TODO implement this function
end


--- setupLegendCard: Sets up the Role cards for the game.
--- @return nil
local function setupRoleCard()
    local boardPattern = ROLE_DISPLAY_BOARD_PATTERN

    local dx, dz = boardPattern.dx, boardPattern.dz
    local dxx, dzz = boardPattern.dxx, boardPattern.dzz
    local dxxx, dzzz = boardPattern.dxxx, boardPattern.dzzz

    print("Enter setupRoleCard")

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

--- setupDeck: Sets up the decks for the game.
--- @return nil
local function setupDeck()
    print("Enter setupDeck")

    -- setup normal deck
    setupNormalDeck(false)
    -- setup card
    setupLegendCard()
    setupRoleCard()
end

--- cleanDevelopmentMode: Cleans up the game when switching out of development mode.
--- @return nil
local function cleanDevelopmentMode()
    -- TODO implement development mode cleanup
    broadcastToAll("Development Mode Disabled")

    -- register deck info
    registerDeckInfo()

    -- setup deck
    Wait.time(setupDeck, 4.0)

    -- set mode to Guest
    GAME:getPublicService():setDevMode(DevMode.Guest)
end

--- SwitchDevMode: for ContextMenu switching development mode on and off.
---@return nil
function SwitchDevMode()
    if GAME:getPublicService():isDevMode() then
        cleanDevelopmentMode()
        return
    end

    broadcastToAll("DevMode has been Disabled, do not use this in Game")
end
