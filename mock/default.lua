---@class JSON
---@field decode fun(str: string): table
---@field encode fun(obj: table): string
JSON = {}

---@class Object
---@field is_face_down boolean If the object is face down
---@field interactable boolean If player can interact with this object
---@field memo string Memo of the object
---@field name string Name of the object
---@field nickname string Nickname of the object
---@field tags string[]? A table of  representing the tags on the contained object.
---@field __call fun(param?: table<string, any>): Object
---@field new fun(param?: table<string, any>): Object
---@field getButtons fun(): table<string, any>[] indexes start at 0
---@field getData fun(): table
---@field getGUID fun(): string
---@field getInputs fun(): table<string, any>[] indexes start at 0
---@field getLock fun(): boolean
---@field getName fun(): string
---@field getObjects fun(): table<string, any>
---@field getPosition fun(): Vector
---@field getRotation fun(): Vector
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
---@field getHandObjects fun(hand_index?: number): Object[] Returns a Table of Objects that are in this hand zone.
---@field pingTable fun(position: Vector): boolean Emulates the player using the ping tool at the given position (tapping Tab).
---@field showOptionsDialog fun(description: string, options: table<string, any>, default_value: number, callback: fun(selected_text: string, selected_index: number, player_color: string)): boolean
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
---@field getNextTurnColor fun(): string?
---@field getPreviousTurnColor fun(): string?
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

---@class WebRequestInstance
---@field is_error boolean If the request failed due to an error.
---@field is_done boolean If the request completed or failed. If the request failed, is_error will be set.
---@field response_code number Response HTTP status code.
---@field url string The request's target URL. If the request was redirected, this will still return the initial URL.
---@field text string Response body.
---@field error string Reason why the request failed to complete. HTTP error (4xx/5xx) is not considered a request error.
---@field download_progress number Download percentage, represented as a number in the range 0-1.
---@field upload_progress number Upload percentage, represented as a number from 0-1.
---@field dispose fun() requests are automatically disposed of after a request completes/fails. You may call this method to try abort a request and dispose of it early.
---@field getResponseHeader fun(name: string): string Returns the value of the specified response header, or nil if no such header exists.
---@field getResponseHeaders fun(): table<string, string> Returns the table of response headers. Keys and values are both strings.


---@class WebRequest
---@field custom fun(url: string, method: string, download: boolean, data: string, headers: table<string, string>, callback_function: function): WebRequestInstance Performs a HTTP request using the specified method, data and headers.
---@field delete fun(url: string, callback_function: function): WebRequestInstance Performs a HTTP DELETE request.
---@field get fun(url: string, callback_function: function): WebRequestInstance Performs a GET request.
---@field head fun(url: string, callback_function: function): WebRequestInstance Performs a HEAD request.
---@field post fun(url: string, form: any, callback_function: function): WebRequestInstance Performs a HTTP POST request, sending the specified form.
---@field put fun(url: string, data: string, callback_function: function): WebRequestInstance Performs a HTTP PUT request, sending the specified data.
WebRequest = {}

---@diagnostic disable-next-line:lowercase-global
self = {}

Global = {}

coroutine = {
    yield = function(val)
        return
    end,
}

--- Adds a menu item to the objects right-click context menu.
---@param label string: Label for the menu item.
---@param callback function: Execute if menu item is selected. Called as callback(player_color, object_position, object)
---@param keep_open boolean: Keep context menu open after menu item was selected (default: false)
---@return boolean result
---@diagnostic disable-next-line:lowercase-global
addContextMenuItem = function(label, callback, keep_open) return true end

--- Clears all menu items added by function addContextMenuItem(...).
---@return boolean result
---@diagnostic disable-next-line:lowercase-global
clearContextMenu = function() return true end

--- Starts a Lua coroutine.
---@param function_owner any: The Object that the function being called is on. Global is a valid target.
---@param function_name string: Name of the function being called as a coroutine.
---@diagnostic disable-next-line:lowercase-global
function startLuaCoroutine(function_owner, function_name) end

--- Returns a table of the Player Colors strings of seated players.
---@return string[] result: The Player Colors strings of seated players.
---@diagnostic disable-next-line:lowercase-global
function getSeatedPlayers() return {} end

---@param message string: The message to broadcast.
---@param message_tint string?: The tint of the broadcasted message.
---@diagnostic disable-next-line:lowercase-global
function broadcastToAll(message, message_tint) end

---@param message string: The message to broadcast.
---@param player_color string: The color of the players to broadcast to.
---@param message_tint? string: The tint of the broadcasted message.
---@diagnostic disable-next-line:lowercase-global
function broadcastToColor(message, player_color, message_tint) end

---@param guid string: The GUID of the object to get.
---@return Object result: The object with the given GUID.
---@diagnostic disable-next-line:lowercase-global
function getObjectFromGUID(guid) return Object() end

---@param param table<string, any>: The parameters for the object to spawn.
---@return Object? result: The spawned object.
---@diagnostic disable-next-line:lowercase-global
function spawnObject(param) return Object() end