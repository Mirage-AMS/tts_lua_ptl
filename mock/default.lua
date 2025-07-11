---@class JSON
---@field decode fun(str: string): table
---@field encode fun(obj: table): string
JSON = {}

---@class Object
---@field __call fun(self: Object, param?: table<string, any>): Object
---@field new fun(self: Object, param?: table<string, any>): Object
---@field getData fun(self: Object): table
---@field getGUID fun(self: Object): string
---@field getName fun(self: Object): string
---@field getObjects fun(self: Object): table<string, any>
---@field getPosition fun(self: Object): Vector
---@field clone fun(self: Object): Object
---@field takeObject fun(self: Object, param: table<string, any>): Object
Object = {}

---@class Player
---@field getAvailableColors fun(self: Player): string[]
---@field getColors fun(self: Player): string[]
---@field getPlayers fun(self: Player): PlayerInstance[]
Player = {}

---@class PlayerInstance
---@field admin boolean if the player is an admin
---@field blindfolded boolean if the player is blindfolded
---@field color string Read-only; the player's color
---@field host boolean Read-only; if the player is the host
---@field lift_height number The lift height for the player. This is how far an object is raised when held in a player's hand. Value is ranged 0 to 1.
---@field promoted boolean if the player is promoted
---@field seated boolean Read-only; if the player is seated
---@field steam_id string Read-only; the player's Steam ID
---@field steam_name string Read-only; the player's Steam Account name
---@field team string The Team of the player. Options: "None", "Clubs", "Diamonds", "Hearts", "Spades", "Jokers".
---@field changeColor fun(self: PlayerInstance, color: string): boolean Changes player to this Player Color.
---@field getHandCount fun(self: PlayerInstance): number Number of hand zones owned by this color.
PlayerInstance = {}

---@class Turns
Turns = {
    order = {},
    turn_color = "",
    enable = false
}

---@class Vector
---@field x number
---@field y number
---@field z number
---@field __call fun(self: Vector, x?: number|table, y?: number, z?: number): Vector
---@field new fun(self: Vector, x?: number|table, y?: number, z?: number): Vector
---@field __add fun(self: Vector, a: Vector): Vector
---@field __sub fun(self: Vector, a: Vector): Vector
---@field __mul fun(self: Vector, a: number|Vector): Vector
Vector = {}

---@class Wait
---@field condition fun(toRunFunc: function, conditionFunc: function, timeout?: number, timeoutFunc?: function): any
---@field frames fun(toRunFunc: function, numberFrames?: number): any
---@field time fun(toRunFunc: function, seconds?: number, repetitions?: number): any
---@field stop fun(id: any): boolean
Wait = {}

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
addContextMenuItem = function(label, callback, keep_open) return true end

--- Clears all menu items added by function addContextMenuItem(...).
---@return boolean result
clearContextMenu = function() return true end

--- Starts a Lua coroutine.
---@param function_owner any: The Object that the function being called is on. Global is a valid target.
---@param function_name string: Name of the function being called as a coroutine.
function startLuaCoroutine(function_owner, function_name) end

--- Returns a table of the Player Colors strings of seated players.
---@return string[]? result: The Player Colors strings of seated players.
function getSeatedPlayers() return {} end

---@param message string: The message to broadcast.
---@param message_tint string?: The tint of the broadcasted message.
function broadcastToAll(message, message_tint) end

---@param message string: The message to broadcast.
---@param player_color string: The color of the players to broadcast to.
---@param message_tint string: The tint of the broadcasted message.
function broadcastToColor(message, player_color, message_tint) end

---@param guid string: The GUID of the object to get.
---@return Object result: The object with the given GUID.
function getObjectFromGUID(guid) return Object() end

---@param param table<string, any>: The parameters for the object to spawn.
---@return Object? result: The spawned object.
function spawnObject(param) return Object() end