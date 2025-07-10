require("src/turn_manager")
require("src/item_manager")
require("src/mode_manager")

---@return PublicService
function FactoryCreatePublicService()
    ---@class PublicService
    ---@field turn_manager TurnManager
    ---@field item_manager ItemManager
    ---@field mode_manager ModeManager
    local service = {}

    -- get function

    --- get game mode manager
    ---@return GameModeManager
    function service:getGameModeManager()
        if self.mode_manager ~= nil then
            return self.mode_manager:getGameModeManager()
        end
        error("fatal error: mode_manager is nil")
    end

    ---@return boolean
    function service:isGameModeSet()
        local gameModeManager = self:getGameModeManager()
        if gameModeManager ~= nil then
            return gameModeManager.is_set
        end
        error("fatal error: game_mode_manager is nil")
    end

    ---@return boolean
    function service:isDevMode()
        if self.mode_manager ~= nil then
            return self.mode_manager:isDevMode()
        end
        error("fatal error: mode_manager is nil")
    end

    ---@param name string: name of board
    ---@return Board
    function service:getPublicBoard(name)
        local publicItemManager = self.item_manager
        if not publicItemManager then
            error("fatal error: publicItemManager is nil")
        end
        return publicItemManager:getBoard(name)
    end

    ---@param name string: name of zone
    ---@return Zone
    function service:getPublicZone(name)
        local publicItemManager = self.item_manager
        if not publicItemManager then
            error("fatal error: publicItemManager is nil")
        end
        return publicItemManager:getZone(name)
    end

    ---@param prefix string: prefix of dev-mode deck (see ref in const_dev_board.lua)
    ---@return any deck: deck of dev-mode
    function service:getDevDeck(prefix)
        local slotIdx = DEVELOPMENT_ZONE_DISPLAY_SLOT_SETUP[prefix]
        if not slotIdx then
            error("fatal error: DEVELOPMENT_ZONE_DISPLAY_SLOT_SETUP[" .. prefix .. "] is nil")
        end
        local devZone = self:getPublicZone(NAME_ZONE_DEVELOPMENT)
        if not devZone then
            error("fatal error: devZone is nil")
        end
        local devZoneDisplaySlots = devZone.display_slots
        if not devZoneDisplaySlots then
            error("fatal error: devZoneDisplaySlots is nil")
        end
        local slot = devZoneDisplaySlots[slotIdx]
        if not slot then
            error("fatal error: devZoneDisplaySlots[" .. slotIdx .. "] is nil")
        end
        return slot:getCardObject()
    end

    -- set function
    ---@param new_mode number: DevMode.DEV | DevMode.GUEST
    ---@return nil
    function service:setDevMode(new_mode)
        if self.mode_manager ~= nil then
            self.mode_manager:setDevMode(new_mode)
            return
        end
        error("fatal error: mode_manager is nil")
    end

    -- Save and Load ----------------------------------------------------------------------------

    --- public service onSave
    ---@return table
    function service:onSave()
        return {
            turn_manager = self.turn_manager:onSave(),
            item_manager = self.item_manager:onSave(),
            mode_manager = self.mode_manager:onSave(),
        }
    end

    --- public service onLoad
    ---@param data table
    ---@return PublicService
    function service:onLoad(data)
        self.turn_manager = FactoryCreateTurnManager():onLoad(data.turn_manager or {})
        self.item_manager = FactoryCreateItemManager():onLoad(data.item_manager or {})
        self.mode_manager = FactoryCreateModeManager():onLoad(data.mode_manager or {})
        return self
    end

    return service
end