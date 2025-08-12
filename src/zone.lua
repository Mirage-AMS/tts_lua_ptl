require("com/const")
require("com/basic")
require("com/object_type")
require("src/slot")
require("src/card")

---@class Zone
---@field name string?
---@field deck_slot Slot?
---@field discard_slot Slot?
---@field display_slots Slot[]?
---@field top_slots Slot[]?
---@field getDeckObj fun(self: Zone): Object?
---@field getRebuildDeckObjFromSlots fun(self: Zone, slots: Slot[]?, flip?: boolean): Object? This function Sync Rebuild Deck
---@field getRebuildDeckObj fun(self: Zone, flip?: boolean): Object? This function Async Rebuild Deck
---@field setObjDiscard fun(self: Zone, obj: Object): nil
---@field shuffleDeck fun(self: Zone): nil
---@field destructDeck fun(self: Zone): nil
---@field dealDeckCardIntoHand fun(self: Zone, count: number, player_color: string, deckFlip?: boolean): nil
---@field dealDeckCardIntoPosition fun(self: Zone, positionTable: Vector[], deckFlip?: boolean, cardFlip?: boolean): nil
---@field fillDisplaySlots fun(self: Zone, deckFlip?: boolean, cardFlip?: boolean): nil
---@field fillTopSlots fun(self: Zone, deckFlip?: boolean, cardFlip?: boolean): nil
---@field __exportData fun(self: Zone, processor: fun(slot: Slot)): table
---@field __importData fun(self: Zone, data: table, processor: fun(slot: Slot)): Zone
---@field onSave fun(self: Zone): table
---@field onSnapshot fun(self: Zone): table
---@field onLoad fun(self: Zone, data: table): Zone

local __zoneSlotTypes = {
    "deck_slot",
    "discard_slot",
    "display_slots",
    "top_slots"
}

---@param array Slot[]?
---@param processor function(slot: Slot): any
local function __processSlotArray(array, processor)
    if not array or #array == 0 then return nil end
    local result = {}
    for i = 1, #array do
        result[i] = processor(array[i])
    end
    return result
end

local ZoneMethods = {
    -- Get Object
    ---@param self Zone
    ---@return Object?
    getDeckObj = function(self)
        if self.deck_slot == nil then
            return nil
        end

        return self.deck_slot:getCardObject()
    end,

    ---@param self Zone
    ---@return Object?
    getDiscardObj = function(self)
        if self.discard_slot == nil then
            return nil
        end

        return self.discard_slot:getCardObject()
    end,

    setObjDiscard = function(self, cardObj)
        if not self.discard_slot then return end
        local pos = self.discard_slot:getPosition()
        pos.y = pos.y + 1.0 + math.random(1, 30) * 0.02
        if not pos then return end
        cardObj.setPositionSmooth(pos)
    end,

    -- Transform Object
    -- @Deprecated
    shuffleDeck = function(self, flip)
        if flip == nil then
            flip = true
        end
        self.deck_slot:shuffle()
        self.deck_slot:setFlipped(flip)
    end,

    destructDeck = function(self)
        local deck = self:getDeckObj()
        if deck then
            deck.destruct()
        end
    end,

    getRebuildDeckObjFromSlots = function(self, slots, flip)
        if flip == nil then flip = true end

        -- quick break if slots is empty
        if slots == nil or #slots == 0 then return nil end

        -- merge card from deck and discard slot
        local deck = nil
        for _, slot in pairs(slots) do
            deck = mergeCard(deck, slot:getMergedCardObject(self.name), self.name)
        end

        if isCardLike(deck) then
            ---@cast deck Object
            if deck.is_face_down ~= flip then
                deck.flip()
            end
            deck.setPosition(self.deck_slot:getPosition())
            deck.shuffle()
        end

        return deck

    end,

    -- mock old function reBuildDeckFromZonesByTag(tag), this function is used to rebuild deck from discard slot and deck slot
    getRebuildDeckObj = function(self, flip)
        return self:getRebuildDeckObjFromSlots({self.deck_slot, self.discard_slot}, flip)
    end,

    dealDeckCard = function(self, count, deckFlip, dealFunc)
        -- param: count: deal card count
        -- param: deckFlip: after shuffle, set deck card flipped or not
        -- param: dealFunc: function(deckObj, startNum, endNum)
        --                  -- param: deckObj: card object
        --                  -- param: startNum, endNum: deal card range
        if not count or count == 0 then return end
        if not dealFunc then return end

        local deck = self:getDeckObj()
        local fDealNum = math.min(count, numCard(deck))
        if fDealNum > 0 then
            dealFunc(deck, 1, fDealNum)
        end

        -- if first deal finished job, break
        if count <= fDealNum then return end

        -- if not finished, wait for next deal
        -- Claim Callback ----------------------------------------------------------
        local toRunFunc = function()
            local deckNew = self:getRebuildDeckObj(deckFlip)
            dealFunc(deckNew, fDealNum + 1, count)
        end

        local conditionFunc = function()
            -- wait until deck is empty (indicate all cards are dealt)
            return not self:getDeckObj()
        end

        local timeoutFunc = function()
            print("warning: deal card timeout")
        end
        -- -- -----------------------------------------------------------------------
        Wait.condition(toRunFunc, conditionFunc,1, timeoutFunc)
    end,

    dealDeckCardIntoHand = function(self, count, player_color, deckFlip)
        local dealFunc = function(deck, startNum, endNum)
            -- incase deal card out of range, clamp it to valid range
            if startNum > endNum then return end
            endNum = math.min(endNum, startNum + numCard(deck) - 1)

            deck.deal(endNum - startNum + 1, player_color)
        end

        self:dealDeckCard(count, deckFlip, dealFunc)
    end,

    dealDeckCardIntoPositions = function(self, positionTable, deckFlip, cardFlip)
        if not positionTable or not #positionTable then return end

        local dealFunc = function(deck, startNum, endNum)
            -- incase deal card out of range, clamp it to valid range
            if startNum > endNum then return end
            startNum = math.max(1, startNum)
            endNum = math.min(#positionTable, endNum)
            endNum = math.min(endNum, startNum + numCard(deck) - 1)

            for idx = startNum, endNum do
                dealCard(deck, positionTable[idx], cardFlip)
            end
        end

        self:dealDeckCard(#positionTable, deckFlip, dealFunc)
    end,

    fillSlots = function(self, slotTable, deckFlip, cardFlip)
        -- quick break if nothing to fill
        if not slotTable or #slotTable == 0 then return end

        local positionTable = {}
        for _, v in ipairs(slotTable) do
            -- find those empty slots and add them to positionTable
            if v ~= nil and v:getCardObject() == nil then
                local pos = v:getPosition()
                if pos then
                    table.insert(positionTable, pos)
                else
                    print("fatal error: slot position is not valid position")
                end
            end
        end

        -- deal cards into empty slots
        self:dealDeckCardIntoPositions(positionTable, deckFlip, cardFlip)
    end,

    fillDisplaySlots = function(self, deckFlip, cardFlip)
        self:fillSlots(self.display_slots, deckFlip, cardFlip)
    end,

    fillTopSlots = function(self, deckFlip, cardFlip)
        self:fillSlots(self.top_slots, deckFlip, cardFlip)
    end,

    ---@param slotProcessor fun(slot: Slot): any
    ---@return table
    __exportData =function(self, slotProcessor)
        local data = {name = self.name}
        for _, slotType in ipairs(__zoneSlotTypes) do
            local value = self[slotType]
            if slotType:find("_slots$") then
                data[slotType] = __processSlotArray(value, slotProcessor)
            else
                data[slotType] = value and slotProcessor(value) or nil
            end
        end
        return data
    end,

    ---@param data table
    ---@param slotProcessor fun(slot: Slot): any
    ---@return Zone
    __importData = function(self, data, slotProcessor)
        if not data then return self end
        for _, slotType in ipairs(__zoneSlotTypes) do
            local value = data[slotType]
            if slotType:find("_slots$") then
                self[slotType] = __processSlotArray(value, slotProcessor)
            else
                self[slotType] = value and slotProcessor(value) or nil
            end
        end
        self.name = data.name
        return self
    end,

    -- 合并后的三个方法
    onSave = function(self)
        return self:__exportData(function(slot)
            return slot:onSave()
        end)
    end,

    onSnapshot = function(self)
        return self:__exportData(function(slot)
            return slot:onSnapshot()
        end)
    end,

    onLoad = function(self, data)
        return self:__importData(data, function(data)
            if not data then return nil end
            return FactoryCreateSlot():onLoad(data)
        end)
    end,
}

---@return Zone
function FactoryCreateZone()
    ---@type Zone
    ---@diagnostic disable-next-line: missing-fields
    local zone = {}

    setmetatable(zone, { __index = ZoneMethods })
    
    return zone
end