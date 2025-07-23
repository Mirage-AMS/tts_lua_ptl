require("src/board")

--- BoardDisplay is a subclass of Board.
--- It adds additional properties and methods specific to displaying boards in the game interface.
---@class BoardDisplay : Board
---@field preference        number
---@field search_text       string
---@field sort_by           number
---@field is_reverse        boolean
---@field page_num          number
---@field page_size         number
---@field max_page_num      number
---@field getDisplayOption  fun(self: BoardDisplay): table
---@field getPageInfo       fun(self: BoardDisplay, info_list: table): table
---@field setPreference     fun(self: BoardDisplay, preference: number): BoardDisplay
---@field setSearchText     fun(self: BoardDisplay, search_text: string): BoardDisplay
---@field setSortBy         fun(self: BoardDisplay, sort_by: number): BoardDisplay
---@field setIsReverse      fun(self: BoardDisplay, is_reverse: boolean): BoardDisplay
---@field setPageNum        fun(self: BoardDisplay, page_num: number): BoardDisplay
---@field setPageSize       fun(self: BoardDisplay, page_size: number): BoardDisplay
---@field setMaxPageNum     fun(self: BoardDisplay, max_page_num: number): BoardDisplay
---@field setMaxPageNumByCount fun(self: BoardDisplay, count: number): BoardDisplay
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
    board.page_size = 6
    board.max_page_num = 99

    function board:getDisplayOption()
        return {
            preference = self.preference,
            search_text = self.search_text,
            sort_by = self.sort_by,
            is_reverse = self.is_reverse,
            page_num = self.page_num,
            page_size = self.page_size,
            max_page_num = self.max_page_num,
        }
    end

    function board:getPageInfo(info_list)
        -- quick break if input is not a table
        if type(info_list) ~= "table" then return {} end

        -- update max_page_num based on total count of info_list
        local total_count = #info_list
        self:setMaxPageNumByCount(total_count)

        -- insure page_num is within valid range
        self.page_num = math.max(1, math.min(self.page_num, self.max_page_num))

        -- locate the start and end index for current page info
        local start_index = (self.page_num - 1) * self.page_size + 1
        local end_index = math.min(self.page_num * self.page_size, total_count)

        -- cut out the page data based on start and end index
        local page_data = {}
        for i = start_index, end_index do
            table.insert(page_data, info_list[i])
        end

        return page_data
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
            self.page_num = math.min(math.max(1, page_num), self.max_page_num)
        end
        return self
    end

    function board:setPageSize(page_size)
        if type(page_size) == "number" then
            self.page_size = page_size
        end
        return self
    end

    function board:setMaxPageNum(max_page_num)
        if type(max_page_num) == "number" then
            self.max_page_num = max_page_num
        end
        return self
    end

    function board:setMaxPageNumByCount(count)
        if type(count) == "number" then
            self.max_page_num = math.max(1, math.ceil(count / self.page_size))
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
                :setPageSize(data.page_size)
                :setMaxPageNum(data.max_page_num)
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
