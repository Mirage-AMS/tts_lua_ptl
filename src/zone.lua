require("com/const")
require("com/basic")
require("com/object_type")
require("src/slot")
require("src/card")

local ZoneMethods = {
    -- Get Object
    ---@param self Zone
    ---@return any
    getDeckObj = function(self)
        if self.deck_slot == nil then
            return nil
        end

        return self.deck_slot:getCardObject()
    end,

    getDiscardObj = function(self)
        if self.discard_slot == nil then
            return nil
        end

        return self.discard_slot:getCardObject()
    end,

    setObjDiscard = function(self, cardObj)
        -- better than putObject
        local pos = self.discard_slot:getPosition()
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

    getRebuildDeckObj = function(self, flip)
        -- mock old function reBuildDeckFromZonesByTag(tag)
        -- this function is used to rebuild deck from discard slot and deck slot
        if flip == nil then
            flip = true
        end

        if not self.deck_slot or not self.discard_slot then
            print("fatal error: deck slot not found")
            return
        end

        -- merge card from deck and discard slot
        local deck = nil
        for _, slot in pairs({self.deck_slot, self.discard_slot}) do
            deck = mergeCard(deck, slot:getMergedCardObject(self.name), self.name)
        end

        if deck and isCardLike(deck) then
            if deck.is_face_down ~= flip then
                deck.flip()
            end
            local pos = self.deck_slot:getPosition()
            deck.setPosition(pos)
            deck.shuffle()
        end

        return deck
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

    -- Save and Load
    onSave = function(self)
        local savedData = {name = self.name}

        local function saveSlot(slot)
            return slot and slot:onSave() or nil
        end

        local function saveSlotArray(array)
            if not array or #array == 0 then return nil end
            local saved = {}
            for i = 1, #array do
                saved[i] = saveSlot(array[i])
            end
            return saved
        end

        local slotTypes = {
            "deck_slot",
            "discard_slot",
            "display_slots",
            "top_slots"
        }

        for _, slotType in ipairs(slotTypes) do
            local value = self[slotType]
            savedData[slotType] = slotType:find("_slots$") and saveSlotArray(value) or saveSlot(value)
        end

        return savedData
    end,

    onLoad = function(self, data)
        if not data then return end

        local function loadSlot(data)
            -- skip those slot with no data
            if not data then return nil end
            return FactoryCreateSlot():onLoad(data)
        end

        local function loadSlotArray(source)
            if not source or #source == 0 then return nil end
            local loaded = {}
            for i = 1, #source do
                loaded[i] = loadSlot(source[i])
            end
            return loaded
        end

        local slotTypes = {
            "deck_slot",
            "discard_slot",
            "display_slots",
            "top_slots"
        }

        for _, slotType in ipairs(slotTypes) do
            local value = data[slotType]
            self[slotType] = slotType:find("_slots$") and loadSlotArray(value) or loadSlot(value)
        end

        self.name = data.name

        return self
    end,

}

---@return Zone
function FactoryCreateZone()
    ---@class Zone
    ---@field name string
    ---@field deck_slot Slot
    ---@field discard_slot Slot
    ---@field display_slots Slot[]
    ---@field top_slots Slot[]
    ---@field getDeckObj fun(self: Zone): any
    ---@field shuffleDeck fun(self: Zone): nil
    ---@field destructDeck fun(self: Zone): nil
    ---@field dealDeckCardIntoHand fun(self: Zone, count: number, player_color: string, deckFlip: boolean | nil): nil
    ---@field dealDeckCardIntoPosition fun(self: Zone, positionTable: Vector[], deckFlip: boolean | nil, cardFlip: boolean | nil): nil
    ---@field onSave fun(self: Zone): table
    ---@field onLoad fun(self: Zone, data: table): Zone
    local zone = {}

    setmetatable(zone, { __index = ZoneMethods })
    
    return zone
end