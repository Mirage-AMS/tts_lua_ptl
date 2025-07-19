require("com/enum")

---@class DevMode
---@field DEV number
---@field GUEST number
---@field __call(number): boolean
DevMode = Enum({ DEV = 1, GUEST = 2, })

---@class EnumDeckSet
---@field STD number
---@field DLC01 number
---@field DLC02 number
---@field __call(number): boolean
EnumDeckSet = Enum({ STD = 1, DLC01 = 2, DLC02 = 3,})

---@class EnumGameGoal
---@field QUICK number
---@field STANDARD number
---@field __call(number): boolean
EnumGameGoal = Enum({QUICK = 1, STANDARD = 2,})

---@class EnumBPStrategy
---@field FREE number
---@field STANDARD number
---@field __call(number): boolean
EnumBPStrategy = Enum({FREE = 1, STANDARD = 2})

---@class EnumRoleDifficulty
---@field EASY number
---@field NORMAL number
---@field HARD number
EnumRoleDifficulty = Enum({EASY = 1, NORMAL = 2, HARD = 3})

---@class EnumRolePreference
---@field NO_PREFERENCE number
---@field PLANT_GATHERING number
---@field MINERAL_GATHERING number
---@field CREATURE_HUNTING number
EnumRolePreference = Enum{NO_PREFERENCE=1, PLANT_GATHERING=2, MINERAL_GATHERING=3, CREATURE_HUNTING=4}

---@class EnumItemOrigin
---@field DEV_DECK number
---@field DEV_CONTAINER number
---@field DEV_CONTAINER_ITEM number
EnumItemOrigin = Enum({DEV_DECK = 1, DEV_CONTAINER = 2, DEV_CONTAINER_ITEM = 3})