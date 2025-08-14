require("mock/default")
require("com/const")
require("com/basic")

---@class TurnManager
---@field first_player string?
---@field current_player string?
---@field last_round number
---@field round number
---@field state number
---@field getFirstPlayer fun(self:TurnManager):string?
---@field setFirstPlayer fun(self:TurnManager, player_color:string?):TurnManager
---@field getCurrentPlayer fun(self:TurnManager):string?
---@field setCurrentPlayer fun(self:TurnManager, player_color:string?):TurnManager
---@field getState fun(self:TurnManager):number
---@field setState fun(self:TurnManager, state:number):TurnManager
---@field addState fun(self:TurnManager):TurnManager
---@field getRound fun(self:TurnManager):number
---@field setRound fun(self:TurnManager, round:number):TurnManager
---@field addRound fun(self:TurnManager):TurnManager
---@field getLastRound fun(self:TurnManager):number
---@field setLastRound fun(self:TurnManager, last_round:number):TurnManager
---@field setCurrentRoundLastRound fun(self:TurnManager): TurnManager
---@field isTurnEnable fun(self:TurnManager):boolean
---@field getTurnColor fun(self:TurnManager):string?
---@field setTurnEnable fun(self:TurnManager, enable: boolean): TurnManager
---@field setTurnColor fun(self:TurnManager, player_color:string?): TurnManager
---@field getNextTurnColor fun(self:TurnManager):string?
---@field getPreviousTurnColor fun(self:TurnManager):string?
---@field isLastRound fun(self:TurnManager):boolean
---@field isGameStart fun(self:TurnManager):boolean
---@field isGameEnd fun(self:TurnManager):boolean
---@field onSave fun(self:TurnManager): table
---@field onSnapshot fun(self:TurnManager): table
---@field onLoad fun(self:TurnManager, data:table): TurnManager

---@return TurnManager
function FactoryCreateTurnManager()
    ---@type TurnManager
    ---@diagnostic disable-next-line: missing-fields
    local manager = {
        first_player = nil,
        current_player = nil,
        last_round = 100,
        round = 0,
        state = 0,
    }

    -- state getter and setter methods
    function manager:getFirstPlayer()
        return self.first_player
    end

    --- set first player if not set yet
    function manager:setFirstPlayer(player_color)
        if not self:getFirstPlayer() then
            self.first_player = player_color
        end
        return self
    end

    function manager:getCurrentPlayer()
        return self.current_player
    end

    function manager:setCurrentPlayer(player_color)
        self.current_player = player_color
        return self
    end

    function manager:getState()
        return self.state
    end

    function manager:setState(state)
        self.state = state
        return self
    end

    function manager:addState()
        self.state = self.state + 1
        return self
    end

    function manager:getRound()
        return self.round
    end

    function manager:setRound(round)
        self.round = math.max(0, round)
        return self
    end

    function manager:addRound()
        self.round = self.round + 1
        return self
    end

    function manager:getLastRound()
        return self.last_round
    end

    function manager:setLastRound(last_round)
        self.last_round = math.max(self:getRound(), last_round)
        return self
    end

    function manager:setCurrentRoundLastRound()
        return self:setLastRound(self:getRound())
    end

    -- BASIC Function
    ---Get if turn is enable or not
    ---@return boolean
    function manager:isTurnEnable()
        return Turns.enable
    end

    ---Get current turn color
    ---@return string?
    function manager:getTurnColor()
        return Turns.turn_color
    end

    ---@param enable boolean
    function manager:setTurnEnable(enable)
        Turns.enable = enable
        return self
    end

    ---@param color string?
    function manager:setTurnColor(color)
        Turns.turn_color = color
        return self
    end

    function manager:getNextTurnColor()
        return Turns.getNextTurnColor()
    end

    function manager:getPreviousTurnColor()
        return Turns.getPreviousTurnColor()
    end

    function manager:isLastRound()
        return self.round == self:getLastRound()
    end

    function manager:isGameStart()
        return self:getFirstPlayer() ~= nil
    end

    function manager:isGameEnd()
        return self.round > self:getLastRound()
    end

    -- Save and Load
    function manager:onSave()
        return {
            first_player = self.first_player,
            current_player = self.current_player,
            round = self.round,
            last_round = self.last_round,
            state = self.state,
        }
    end

    function manager:onSnapshot()
        return self:onSave()
    end

    ---@param data table
    ---@return TurnManager
    function manager:onLoad(data)
        self.first_player = data.first_player
        return self:setCurrentPlayer(data.current_player)
                   :setRound(data.round)
                   :setLastRound(data.last_round)
                   :setState(data.state)
    end

    return manager
end