require("mock/default")
require("com/object_type")


local SlotMethods = {
    getPosition = function(self)
        if self.object and isScripting(self.object) then
            -- Returns a Vector of the current World Position.
            return self.object.getPosition()
        end
        return nil
    end,

    getObjects = function(self, ignore_tags)
        -- default as true
        if ignore_tags == nil then
            ignore_tags = true
        end
        if not (self.object and isScripting(self.object)) then
            return nil
        end

        return self.object.getObjects(ignore_tags)
    end,

    getCardObjects = function(self)
        local objList = self:getObjects(false)

        if objList == nil or #objList == 0 then
            return {}
        end

        local cards = {}
        for _, obj in ipairs(objList) do
            if isCardLike(obj) then
                table.insert(cards, obj)
            end
        end

        return cards
    end,

    getCardObject = function(self, isFirst)
        -- Returns the first or last cardlike object in this slot.
        -- param: (Optional) [bool] isFirst:
        -- -- if true, return the first cardlike object; else return the last one.
        -- -- Default is false.
        -- return: [obj | nil] the first or last cardlike object in this slot.
        if isFirst == nil then isFirst = false end

        local cards = self:getCardObjects()
        if cards and #cards > 0 then
            return cards[isFirst and 1 or #cards]
        end
        return nil
    end,

    getMergedCardObject = function(self, tag)
        -- NEW FUNCTION: merge all cardlike objects in this slot into a deck
        -- param: (Optional) [str] tag: the tag of the merged deck.
        local deck = nil

        -- quick break if no object
        local objList = self:getCardObjects()
        if not objList or #objList == 0 then
            return deck
        end

        -- merge all cardlike objects in this slot
        for _, obj in ipairs(objList) do
            deck = mergeCard(deck, obj, tag)
        end

        return deck
    end,

    shuffle = function(self)
        -- only shuffle the first cardlike object
        local obj = self:getCardObject()

        if obj and isCardLike(obj) then
            obj.shuffle()
        end
    end,

    setFlipped = function(self, flip)
        -- quick break if no object
        local objList = self:getObjects()
        if not objList or #objList == 0 then
            return
        end

        for _, obj in ipairs(objList) do
            if obj and (isCardLike(obj) or isTile(obj)) then
                if not obj.getLock() and obj.is_face_down ~= flip then
                    obj.flip()
                end
            end
        end

    end,

    setStraight = function(self)
        -- quick break if no object
        local objList = self:getObjects()
        if not objList or #objList == 0 then
            return
        end

        for _, obj in ipairs(objList) do
            if obj and (isCardLike(obj) or isTokenLike(obj)) then
                if not obj.getLock() then
                    local rotation = obj.is_face_down and {x=0, y=180, z=180} or {x=0, y=180, z=0}
                    obj.setRotation(rotation)
                end
            end
        end

    end,

    -- Save and Load
    onSave = function(self)
        return {guid=self.guid}
    end,

    onLoad = function(self, data)
        self.guid = data.guid
        if self.guid then
            self.object = getObjectFromGUID(self.guid)
            if not self.object then
                error("fatal error: failed to load object with GUID " .. self.guid)
            end
            return self
        end

        local param = data.param
        if not param then
            error("error: missing object creation parameters")
            return self
        end

        -- 处理参考对象位置偏移
        local positionShift = Vector(0, 0, 0)
        local refGUID = data.ref
        if refGUID then
            local refObject = getObjectFromGUID(refGUID)
            if refObject then
                positionShift = refObject.getPosition()
            else
                print("warning: reference GUID " .. refGUID .. " not exists")
            end
        end

        -- 应用位置偏移
        local pos = Vector(param.position or {0, 0, 0})
        param.position = pos + positionShift

        -- 生成对象
        local object = spawnObject(param)
        if object then
            self.guid = object.getGUID()
            self.object = object
        else
            error("fatal error: failed to spawn scriptting zone object".. tableToString(param))
        end

        return self
    end,
}

---@return Slot
function FactoryCreateSlot()
    ---@class Slot
    local slot = {
        guid = nil,
        object = nil
    }

    -- 关联预定义的方法表
    setmetatable(slot, {__index = SlotMethods})

    return slot
end