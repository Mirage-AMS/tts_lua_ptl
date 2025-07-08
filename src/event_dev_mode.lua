require("com/const")
require("com/enum_const")
require("com/dev_const")
require("com/object_type")
require("src/card")

-- registerDeckInfo: Register deck information for the game.
local function registerDeckInfo()
    print("Enter registerDeckInfo")

    local devZoneName = NAME_ZONE_DEVELOPMENT
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
    local setup = DEVELOPMENT_ZONE_DISPLAY_SLOT_SETUP

    for _, prefix in ipairs(all_deck_list) do
        -- deck
        local eachSlotIdx = setup[prefix]
        local eachSlot = devZoneDisplaySlots[eachSlotIdx]
        if not eachSlot then
            error("fatal error: devZoneDisplaySlots[" .. eachSlotIdx .. "] is nil")
        end
        local eachDeck = eachSlot:getCardObject()
        if not eachDeck then
            error("fatal error: devZoneDisplaySlots[" .. eachSlotIdx .. "]:getCardObject() is nil")
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
    local devZoneName = NAME_ZONE_DEVELOPMENT
    local setup = DEVELOPMENT_ZONE_DISPLAY_SLOT_SETUP

    local publicItemManager = GAME:getPublicItemManager()
    if not publicItemManager then
        error("fatal error: publicItemManager is nil")
    end
    local devZone = publicItemManager:getZone(devZoneName)
    if not devZone then
        error("fatal error: devZone is nil")
    end
    local devZoneDisplaySlots = devZone.display_slots
    if not devZoneDisplaySlots then
        error("fatal error: devZoneDisplaySlots is nil")
    end

    for zoneName, deckList in pairs(zoneReflect) do
        local zone = publicItemManager:getZone(zoneName)
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
            local eachSlotIdx = setup[prefix]
            local eachSlot = devZoneDisplaySlots[eachSlotIdx]
            if not eachSlot then
                error("fatal error: devZoneDisplaySlots[" .. eachSlotIdx .. "] is nil")
            end
            local eachDeck = eachSlot:getCardObject()
            if not eachDeck then
                error("fatal error: devZoneDisplaySlots[" .. eachSlotIdx .. "]:getCardObject() is nil")
            end
            eachDeck.clone({position = pos})
            pos.y = pos.y + _eachShift
        end
    end
end

--- setupLegendCard: Sets up the Role cards for the game.
--- @return nil
local function setupRoleCard()
    -- TODO: implement role card setup
end

--- setupDeck: Sets up the decks for the game.
--- @return nil
local function setupDeck()
    print("Enter setupDeck")

    -- setup normal deck
    setupNormalDeck(false)
    -- setup card
    -- setupLegendCard()
    setupRoleCard()
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

    -- register deck info
    registerDeckInfo()

    -- setup deck
    Wait.time(setupDeck, 4.0)

    -- set mode to Guest
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
