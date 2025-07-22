require("src/board")

--- BoardDisplay is a subclass of Board.
--- It adds additional properties and methods specific to displaying boards in the game interface.
---@class BoardDisplay : Board
---@field preference        number
---@field search_text       string
---@field sort_by           number
---@field is_reverse        boolean
---@field page_num          number
---@field getDisplayOption  fun(self: BoardDisplay): table
---@field setPreference     fun(self: BoardDisplay, preference: number): BoardDisplay
---@field setSearchText     fun(self: BoardDisplay, search_text: string): BoardDisplay
---@field setSortBy         fun(self: BoardDisplay, sort_by: number): BoardDisplay
---@field setIsReverse      fun(self: BoardDisplay, is_reverse: boolean): BoardDisplay
---@field setPageNum        fun(self: BoardDisplay, page_num: number): BoardDisplay
---@field setDisplayOption  fun(self: BoardDisplay, data: table): BoardDisplay
---@field onSave            fun(self: BoardDisplay): table
---@field onLoad            fun(self: BoardDisplay, data: table): BoardDisplay

--- A factory function to create a new BoardDisplay object.
---@return BoardDisplay
function FactoryCreateBoardDisplay()
    --- @type Board
    local parentInstance = FactoryCreateBoard()
    --- @type BoardDisplay
    local board = setmetatable({}, {__index = parentInstance})

    --- Initialize the additional properties for BoardDisplay.
    board.preference = EnumRolePreference.NONE
    board.search_text = ""
    board.sort_by = EnumDisplayBoardSort.DIFFICULTY
    board.is_reverse = false
    board.page_num = 1

    function board:getDisplayOption()
        return {
            preference = self.preference,
            search_text = self.search_text,
            sort_by = self.sort_by,
            is_reverse = self.is_reverse,
            page_num = self.page_num
        }
    end

    function board:setPreference(preference)
        if EnumRolePreference(preference) then
            self.preference = preference
        end
        return self
    end

    function board:setSearchText(search_text)
        if type(search_text) == "string" then
            self.search_text = search_text
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

    function board:setDisplayOption(data)
        if data ~= nil then
            self:setPreference(data.preference)
                :setSearchText(data.search_text)
                :setSortBy(data.sort_by)
                :setIsReverse(data.is_reverse)
                :setPageNum(data.page_num)
        end
        return self
    end

    function board:onSave()
        --- super onSave
        local data = parentInstance.onSave(self)
        --- set additional properties
        for k, v in pairs(self:getDisplayOption()) do
            data[k] = v
        end
        return data
    end

    function board:onLoad(data)
        --- super onLoad
        parentInstance.onLoad(self, data)
        --- set additional properties
        return self:setDisplayOption(data)
    end

    return board
end
