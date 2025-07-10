require("mock/default")
require("com/const")
require("com/basic")

---@return TurnManager
function FactoryCreateTurnManager()
    ---@class TurnManager
    ---@field first_player string
    ---@field current_player string
    ---@field round number
    ---@field state number
    local manager = {
        first_player = nil,
        current_player = nil,
        round = 0,
        state = 0,
    }

    -- state getter and setter methods
    function manager:getFirstPlayer()
        return self.first_player
    end

    function manager:setFirstPlayer(player_color)
        if self:getFirstPlayer() ~= nil then
            return false
        end
        self.first_player = player_color
        return true
    end

    function manager:getCurrentPlayer()
        return self.current_player
    end

    function manager:setCurrentPlayer(player_color)
        self.current_player = player_color
    end

    function manager:getState()
        return self.state
    end

    function manager:setState(state)
        self.state = state
        return true
    end

    function manager:addState()
        self.state = self.state + 1
    end

    function manager:getRound()
        return self.round
    end

    function manager:setRound(round)
        self.round = round
        return true
    end

    function manager:addRound()
        self.round = self.round + 1
    end

    -- BASIC Function
    function manager:isTurnEnable()
        return Turns.enable
    end

    function manager:getTurnColor()
        return Turns.turn_color
    end

    function manager:setTurnEnable(enable)
        Turns.enable = enable
    end

    function manager:setTurnColor(color)
        Turns.turn_color = color
    end

    function manager:getNextTurnColor()
        return Turns.getNextTurnColor()
    end

    function manager:getPreviousTurnColor()
        return Turns.getPreviousTurnColor()
    end

    function manager:isGameStart()
        return self:getFirstPlayer() ~= nil
    end

    -- Save and Load
    function manager:onSave()
        return {
            first_player = self.first_player,
            current_player = self.current_player,
            round = self.round,
            state = self.state,
        }
    end

    ---@param data table
    ---@return TurnManager
    function manager:onLoad(data)
        self.first_player = data.first_player
        self.current_player = data.current_player
        self.round = data.round
        self.state = data.state
        return self
    end

    return manager
end