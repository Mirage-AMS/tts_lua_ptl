require("src/board")

--- BoardDisplay is a subclass of Board.
--- It adds additional properties and methods specific to displaying boards in the game interface.
---@class BoardDisplay : Board
---@field preference    number
---@field sort_by       number
---@field is_reverse    boolean
---@field page_num      number
---@field setPreference fun(self: BoardDisplay, preference: number): BoardDisplay
---@field setSortBy     fun(self: BoardDisplay, sort_by: number): BoardDisplay
---@field setIsReverse  fun(self: BoardDisplay, is_reverse: boolean): BoardDisplay
---@field setPageNum    fun(self: BoardDisplay, page_num: number): BoardDisplay
---@field set           fun(self: BoardDisplay, data: table): BoardDisplay
---@field onSave        fun(self: BoardDisplay): table
---@field onLoad        fun(self: BoardDisplay, data: table): BoardDisplay

--- A factory function to create a new BoardDisplay object.
---@return BoardDisplay
function FactoryCreateBoardDisplay()
    --- @type Board
    local parentInstance = FactoryCreateBoard()
    --- @type BoardDisplay
    local board = setmetatable({}, {__index = parentInstance})

    --- Initialize the additional properties for BoardDisplay.
    board.preference = EnumRolePreference.NONE
    board.sort_by = EnumDisplayBoardSort.DIFFICULTY
    board.is_reverse = false
    board.page_num = 1

    function board:setPreference(preference)
        if EnumRolePreference(preference) then
            self.preference = preference
        end
        return self
    end

    function board:setSortBy(sort_by)
        if EnumDisplayBoardSort(sort_by) then
            self.sort_by = sort_by
        end
        return self
    end

    function board:setIsReverse(is_reverse)
        if type(is_reverse) == "boolean" then
           self.is_reverse = is_reverse
        end
        return self
    end

    function board:setPageNum(page_num)
        if type(page_num) == "number" then
            self.page_num = page_num
        end
        return self
    end

    function board:set(data)
        if data ~= nil then
            self:setPreference(data.preference)
                :setSortBy(data.sort_by)
                :setIsReverse(data.is_reverse)
                :setPageNum(data.page_num)
        end
        return self
    end

    function board:onSave()
        local data = parentInstance.onSave(self)
        data.preference = self.preference
        data.sort_by = self.sort_by
        data.is_reverse = self.is_reverse
        data.page_num = self.page_num
        return data
    end

    function board:onLoad(data)
        --- super onLoad
        parentInstance.onLoad(self, data)
        --- set additional properties
        return self:set(data)
    end

    return board
end
