require("com/enum_const")
require("com/dev_const")
require("com/object_type")
require("src/card")

-- registerDeckInfo: Register deck information for the game.
local function registerDeckInfo()

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
