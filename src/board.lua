require("mock/default")

---@class Board
---@field guid string?
---@field object Object?
---@field getPosition fun(self: Board): Vector
---@field createButton fun(self: Board, param: table)
---@field getButtons fun(self: Board): table<string, any>
---@field editButton fun(self: Board, param: table)
---@field setInteractable fun(self: Board, interactable: boolean)
---@field getValueByIndex fun(self: Board, index: number): number?
---@field tiltValueByIndex fun(self: Board, index: number, value: number)
---@field onSave fun(self: Board): table
---@field onLoad fun(self: Board, data: table): Board

---@return Board
function FactoryCreateBoard()
    local board = {
        guid = nil,
        object = nil
    }

    -- get Method
    ---@return Vector
    function board:getPosition()
        if not self.object then
            error("fatal error: Board object is nil")
        end
        return self.object.getPosition()
    end

    --------------------------------------------------------
    -- Button Methods
    --------------------------------------------------------
    function board:createButton(param)
        if not self.object then
            error("fatal error: Board object is nil")
        end
        self.object.createButton(param)
    end

    function board:getButtons()
        if not self.object then
            error("fatal error: Board object is nil")
        end
        return self.object.getButtons()
    end

    function board:editButton(param)
        if not self.object then
            error("fatal error: Board object is nil")
        end
        self.object.editButton(param)
    end

    ---@param interactable boolean if false, the board will not be interactable (button still interactable)
    function board:setInteractable(interactable)
        if not self.object then
            error("fatal error: Board object is nil")
        end
        self.object.interactable = interactable
    end
    -- --------------------------------------------------
    -- Function Below only applies to Role Board
    -- --------------------------------------------------
    function board:getValueByIndex(index)
        if not self.object then
            error("fatal error: Board object is nil")
        end
        local input = (self.object.getInputs() or {})[index]
        return input and tonumber(input["value"]) or nil
    end

    function board:tiltValueByIndex(index, value)
        if not self.object then
            error("fatal error: Board object is nil")
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

        if not self.object then
            error("fatal error: Board with guid" .. data.guid .. " not found")
        end

        return self
    end

    return board
end