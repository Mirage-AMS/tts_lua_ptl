Turns = {
    order = {},
    turn_color = "",
    enable = false
}

Player = {
    getPlayers = function() return {} end,
}

JSON = {
    decode = function(str) return {} end,
    encode = function(obj) return "" end,
}

---@class Vector
---@field x number
---@field y number
---@field z number
Vector = {
    __index = Vector,   -- if can't find a key in Vector, look for it in this table

    new = function(self, x, y, z)
        local instance = setmetatable({}, self) -- gift the empty table a metatable from self (Vector)

        if type(x) == "table" then
            instance.x = x.x or 0
            instance.y = x.y or 0
            instance.z = x.z or 0
        elseif type(x) == "number" then
            instance.x = x or 0
            instance.y = y or 0
            instance.z = z or 0
        else
            error("Invalid arguments to Vector.new")
        end

        return instance
    end,

    ---@param a Vector
    ---@param b Vector
    ---@return Vector result
    __add = function(a, b)
        return Vector:new(a.x + b.x, a.y + b.y, a.z + b.z)
    end,

    ---@param a Vector
    ---@param b Vector
    ---@return Vector result
    __sub = function(a, b)
        return Vector:new(a.x - b.x, a.y - b.y, a.z - b.z)
    end,

    ---@param a Vector|number a
    ---@param b Vector|number b
    ---@return Vector result
    __mul = function(a, b)
        if type(a) == "number" then
            return Vector:new(b.x * a, b.y * a, b.z * a)
        elseif type(b) == "number" then
            return Vector:new(a.x * b, a.y * b, a.z * b)
        else
            error("Invalid arguments to Vector.__mul")
        end
    end,
}

setmetatable(Vector, {
    __call = Vector.new
})

Wait = {
    condition = function(toRunFunc, conditionFunc, timeout, timeoutFunc)
        -- [func] toRunFunc: The function to be executed after the specified condition is met.
        -- [func] conditionFunc: The function that will be executed repeatedly, until it returns true (or the timeout is reached).
        -- [float] timeout: The amount of time (in seconds) that may elapse before the scheduled function is cancelled.
        -- /* Optional, defaults to never timing out. */
        -- [func] timeoutFunc: The function that will be executed if the timeout is reached.
        -- /* Optional */
        -- Returns: The ID of the scheduled function.
    end,
    frames = function(toRunFunc, numberFrames)
        -- [func] toRunFunc: The function to be executed after the specified number of frames.
        -- [int] numberFrames: The number of frames that must elapse before toRunFunc is executed.
        -- /* Optional, defaults to 1 frame. */
        -- Returns: The ID of the scheduled function.
    end,
    time = function(toRunFunc, seconds, repetitions)
        -- [func] toRunFunc: The function to be executed after the specified number of seconds.
        -- [float] seconds: The number of seconds to wait before executing the function.
        -- [int] repetitions: Number of times toRunFunc will be (re)scheduled. -1 is infinite repetitions.
        -- /* Optional, defaults to 1 repetition. */
        -- Returns: The ID of the scheduled function.
    end,
    stop = function(id)
        -- [int] id: A wait ID (returned from Wait scheduling functions).
        -- Returns: true if the function was stopped, false otherwise.
    end
}

self = {}
Global = {}

coroutine = {
    yield = function(val)
        return
    end,
}

--- Adds a menu item to the objects right-click context menu.
--- @param label string: Label for the menu item.
--- @param callback function: Execute if menu item is selected. Called as callback(player_color, object_position, object)
--- @param keep_open boolean: Keep context menu open after menu item was selected (default: false)
--- @return boolean result
addContextMenuItem = function(label, callback, keep_open)
    return true
end

--- Starts a Lua coroutine.
---@param function_owner any: The Object that the function being called is on. Global is a valid target.
---@param function_name string: Name of the function being called as a coroutine.
function startLuaCoroutine(function_owner, function_name)
end

function getSeatedPlayers()
    -- Returns a Table of the Player Colors strings of seated players.
    return {"Red", "Purple", "Yellow", "Blue"}
end

function broadcastToAll(message, message_tint)
    -- [string] message: The message to broadcast.
    -- [string] message_tint: The tint of the broadcasted message.
end

function broadcastToColor(message, player_color, message_tint)
    -- [string] message: The message to broadcast.
    -- [string] player_color: The color of the players to broadcast to.
    -- [string] message_tint: The tint of the broadcasted message.
end

function getObjectFromGUID(guid)
    -- [string] guid: The GUID of the object to get.
    return {}
end

function spawnObject(param)
    return {}
end