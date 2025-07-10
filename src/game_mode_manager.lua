require("com/enum_const")


---@return GameModeManager
function FactoryCreateGameModeManager()
    ---@class GameModeManager
    ---@field is_set boolean
    ---@field deck_set number: default as EnumDeckSet.STD
    ---@field game_goal number: default as EnumGameGoal.QUICK
    ---@field enable_role boolean: default as false
    ---@field bp_strategy number: default as EnumBPStrategy.STANDARD
    local game_mode_manager = {
        is_set = false,
        enable_role = false,
        deck_set = EnumDeckSet.STD,
        game_goal = EnumGameGoal.QUICK,
        bp_strategy = EnumBPStrategy.STANDARD
    }

    -- set functions
    function game_mode_manager:setIsSet(isSet)
        if isSet ~= nil and type(isSet) == "boolean" then
            self.is_set = isSet
        end
        return self
    end

    function game_mode_manager:setDeckSet(deckSet)
        if EnumDeckSet(deckSet) then
            self.deck_set = deckSet
        end
        return self
    end

    function game_mode_manager:setGameGoal(gameGoal)
        if EnumGameGoal(gameGoal) then
            self.game_goal = gameGoal
        end
        return self
    end

    function game_mode_manager:setEnableRole(enableRole)
        if enableRole ~= nil and type(enableRole) == "boolean" then
            self.enable_role = enableRole
        end
        return self
    end

    function game_mode_manager:setBPStrategy(bpStrategy)
        if EnumBPStrategy(bpStrategy) then
            self.bp_strategy = bpStrategy
        end
        return self
    end

    -- onLoad and onSave
    function game_mode_manager:set(data)
        if data ~= nil then
            self:setIsSet(data.is_set)
                :setDeckSet(data.deck_set)
                :setGameGoal(data.game_goal)
                :setEnableRole(data.enable_role)
                :setBPStrategy(data.bp_strategy)
        end
        return self
    end

    function game_mode_manager:onSave()
        return {
            is_set = self.is_set,
            deck_set = self.deck_set,
            game_goal = self.game_goal,
            enable_role = self.enable_role,
            bp_strategy = self.bp_strategy,
        }
    end

    ---@param data table: onLoad data
    ---@return GameModeManager
    function game_mode_manager:onLoad(data)
        return self:set(data)
    end

    return game_mode_manager
end