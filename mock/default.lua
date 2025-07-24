---@class JSON
---@field decode fun(str: string): table
---@field encode fun(obj: table): string
JSON = {}

---@class Object
---@field is_face_down boolean If the object is face down
---@field interactable boolean If player can interact with this object
---@field __call fun(param?: table<string, any>): Object
---@field new fun(param?: table<string, any>): Object
---@field getButtons fun(): table<string, any>[] indexes start at 0
---@field getData fun(): table
---@field getGUID fun(): string
---@field getInputs fun(): table<string, any>[] indexes start at 0
---@field getName fun(): string
---@field getObjects fun(): table<string, any>
---@field getPosition fun(): Vector
---@field attachInvisibleHider fun(id: string, hidden: boolean, players: string[]?)
---@field call fun(func_name: string, func_param?: any): any Used to call a Lua function on another entity.
---@field clone fun(param: table): Object
---@field createButton fun(param: table<string, any>): boolean
---@field createInput fun(param: table<string, any>): boolean
---@field destruct fun(): boolean
---@field editButton fun(param: table<string, any>): boolean
---@field editInput fun(param: table<string, any>): boolean
---@field flip fun(): boolean
---@field putObject fun(obj: Object): Object
---@field setLock fun(lock: boolean): boolean
---@field setRotation fun(vector: Vector): boolean
---@field setRotationSmooth fun(vector: Vector, collide?: boolean, fast?: boolean): boolean
---@field setPosition fun(vector: Vector): boolean
---@field setPositionSmooth fun(vector: Vector, collide?: boolean, fast?: boolean): boolean
---@field shuffle fun(): boolean
---@field takeObject fun(param?: table<string, any>): Object
Object = {}

---@class Player
---@field getAvailableColors fun(): string[]
---@field getColors fun(): string[]
---@field getPlayers fun(): PlayerInstance[]
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
---@field changeColor fun(color: string): boolean Changes player to this Player Color.
---@field getHandCount fun(): number Number of hand zones owned by this color.
PlayerInstance = {}

---@class Turns
---@field enable boolean
---@field type number
---@field order string[]
---@field reverse_order boolean
---@field skip_empty_hands boolean
---@field disable_interactations boolean
---@field pass_turns boolean
---@field turn_color string
---@field getNextTurnColor fun(): string
---@field getPreviousTurnColor fun(): string[]
Turns = {}

---@class Time a static global class which provides access to Unity's time information.
---@field time number The current time. Works like os.time() but is more accurate. Read only.
---@field delta_time number The amount of time since the last frame. Read only.
---@field fixed_delta_time number The interval (in seconds) between physics updates. Read only.
Time = {}

---@class Vector
---@field x number
---@field y number
---@field z number
---@field __call fun(self: Vector, x?: number|table, y?: number, z?: number): Vector
---@field new fun(self: Vector, x?: number|table, y?: number, z?: number): Vector
---@field __add fun(self: Vector, a: Vector): Vector
---@field __sub fun(self: Vector, a: Vector): Vector
---@field __mul fun(self: Vector, a: number): Vector  -- 向量×数字返回Vector
---@field __mul fun(self: Vector, a: Vector): number  -- 向量×向量返回点积（数字）
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
---@return string[] result: The Player Colors strings of seated players.
function getSeatedPlayers() return {} end

---@param message string: The message to broadcast.
---@param message_tint string?: The tint of the broadcasted message.
function broadcastToAll(message, message_tint) end

---@param message string: The message to broadcast.
---@param player_color string: The color of the players to broadcast to.
---@param message_tint? string: The tint of the broadcasted message.
function broadcastToColor(message, player_color, message_tint) end

---@param guid string: The GUID of the object to get.
---@return Object result: The object with the given GUID.
function getObjectFromGUID(guid) return Object() end

---@param param table<string, any>: The parameters for the object to spawn.
---@return Object? result: The spawned object.
function spawnObject(param) return Object() end