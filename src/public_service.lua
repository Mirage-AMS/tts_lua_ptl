require("src/turn_manager")
require("src/item_manager")
require("src/mode_manager")

function FactoryCreatePublicService()
    local service = {
        turn_manager = {},
        item_manager = {},
        mode_manager = {},
    }

    -- get function
    function service:isDevelopmentMode()
        if self.mode_manager then
            return self.mode_manager:isDevelopmentMode()
        end
        error("fatal error: mode_manager is nil")
    end

    function service:getPublicBoard(name)
        local publicItemManager = self.item_manager
        if not publicItemManager then
            error("fatal error: publicItemManager is nil")
        end
        return publicItemManager:getBoard(name)
    end

    function service:getPublicZone(name)
        local publicItemManager = self.item_manager
        if not publicItemManager then
            error("fatal error: publicItemManager is nil")
        end
        return publicItemManager:getZone(name)
    end

    ---@param prefix string: prefix of dev-mode deck (see ref in dev_const.lua)
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
    function service:setMode(new_mode)
        if self.mode_manager ~= nil then
            self.mode_manager:setMode(new_mode)
            return
        end
        error("fatal error: mode_manager is nil")
    end

    -- Save and Load
    function service:onSave()
        return {
            turn_manager = self.turn_manager:onSave(),
            item_manager = self.item_manager:onSave(),
            mode_manager = self.mode_manager:onSave(),
        }
    end

    function service:onLoad(data)
        self.turn_manager = FactoryCreateTurnManager():onLoad(data.turn_manager or {})
        self.item_manager = FactoryCreateItemManager():onLoad(data.item_manager or {})
        self.mode_manager = FactoryCreateModeManager():onLoad(data.mode_manager or {})
        return self
    end

    return service
end