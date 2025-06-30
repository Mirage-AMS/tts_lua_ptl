function FactoryCreateBoard()
    local board = {
        guid = nil,
        object = nil
    }

    --------------------------------------------------------
    -- Button Methods
    --------------------------------------------------------
    function board:createButton(param)
        if not self.object then
            print("Board not found")
            return nil
        end
        self.object.createButton(param)
    end

    function board:getButtons()
        if not self.object then
            print("Board not found")
            return nil
        end
        return self.object.getButtons()
    end

    function board:editButton(param)
        if not self.object then
            print("Board not found")
            return
        end
        self.object.editButton(param)
    end

    -- --------------------------------------------------
    -- Function Below only applies to Role Board
    -- --------------------------------------------------
    function board:getValueByIndex(index)
        if not self.object then
            print("Board not found")
            return
        end
        local input = (self.object.getInputs() or {})[index]
        return input and tonumber(input["value"]) or nil
    end

    function board:tiltValueByIndex(index, value)
        if not self.object then
            print("Board not found")
            return
        end

        if value == 0 then return end
        local funcName = value > 0 and "increaseCounter" or "decreaseCounter"
        local absValue = math.abs(value)

        for _ = 1, absValue do
            self.object.call(funcName, {index, 1, DEFAULT_COLOR_BLACK})
        end
    end

    -- Save and Load
    function board:onSave()
        return {
            guid = self.guid
        }
    end

    function board:onLoad(data)
        self.guid = data.guid
        self.object = getObjectFromGUID(data.guid)
        return self
    end

    return board
end