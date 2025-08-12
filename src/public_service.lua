require("mock/default")
require("src/turn_manager")
require("src/item_manager")
require("src/mode_manager")

---@class PublicService
---@field turn_manager TurnManager?
---@field item_manager ItemManager?
---@field mode_manager ModeManager?
---@field getTurnManager fun(self: PublicService): TurnManager
---@field getItemManager fun(self: PublicService): ItemManager
---@field getModeManager fun(self: PublicService): ModeManager
---@field getGameModeManager fun(self: PublicService): GameModeManager
---@field isGameModeSet fun(self: PublicService): boolean
---@field isDevMode fun(self: PublicService): boolean
---@field getPublicBoard fun(self: PublicService, name: string): Board?
---@field getPublicZone fun(self: PublicService, name: string): Zone?
---@field getDevDeck fun(self: PublicService, prefix: string): Object?
---@field setDevMode fun(self: PublicService, new_mode: number)
---@field onSave fun(self: PublicService): table
---@field onSnapshot fun(self: PublicService): table
---@field onLoad fun(self: PublicService, data: table): PublicService

---@return PublicService
function FactoryCreatePublicService()
    ---@type PublicService
    ---@diagnostic disable-next-line: missing-fields
    local service = {
        turn_manager = nil,
        item_manager = nil,
        mode_manager = nil,
    }

    -- get function
    --- check and get turn manager
    ---@return TurnManager
    function service:getTurnManager()
        if not self.turn_manager then
            error("fatal error: turn_manager is nil")
        end
        return self.turn_manager
    end

    --- get item manager
    --- check and get item manager
    ---@return ItemManager
    function service:getItemManager()
        if not self.item_manager then
            error("fatal error: item_manager is nil")
        end
        return self.item_manager
    end

    --- get mode manager
    --- check and get mode manager
    ---@return ModeManager
    function service:getModeManager()
        if not self.mode_manager then
            error("fatal error: mode_manager is nil")
        end
        return self.mode_manager
    end

    --- get game mode manager
    ---@return GameModeManager
    function service:getGameModeManager()
        return self:getModeManager():getGameModeManager()
    end

    ---@return boolean
    function service:isGameModeSet()
        return self:getGameModeManager().is_set
    end

    ---@return boolean
    function service:isDevMode()
        return self:getModeManager():isDevMode()
    end

    ---@param name string: name of board
    ---@return Board?
    function service:getPublicBoard(name)
        return self:getItemManager():getBoard(name)
    end

    ---@param name string: name of zone
    ---@return Zone?
    function service:getPublicZone(name)
        return self:getItemManager():getZone(name)
    end

    ---@param prefix string: prefix of dev-mode deck (see ref in const_dev_board.lua)
    ---@return Object? deck: deck of dev-mode
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
        self:getModeManager():setDevMode(new_mode)
    end

    -- Save and Load ----------------------------------------------------------------------------

    --- public service onSave
    ---@return table
    function service:onSave()
        return {
            turn_manager = self:getTurnManager():onSave(),
            --- item_manager = self:getItemManager():onSave(),
            mode_manager = self:getModeManager():onSave(),
        }
    end

    ---@return table
    function service:onSnapshot()
        return {
            turn_manager = self:getTurnManager():onSnapshot(),
            item_manager = self:getItemManager():onSnapshot(),
            mode_manager = self:getModeManager():onSnapshot(),
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