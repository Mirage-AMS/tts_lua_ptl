require("com/enum")

---@class DevMode
---@field DEV number
---@field GUEST number
---@operator call(number):boolean
DevMode = Enum({ DEV = 1, GUEST = 2, })

---@class EnumDeckSet
---@field STD number
---@field DLC01 number
---@field DLC02 number
---@operator call(number):boolean
EnumDeckSet = Enum({ STD = 1, DLC01 = 2, DLC02 = 3,})

---@class EnumGameGoal
---@field QUICK number
---@field STANDARD number
---@operator call(number):boolean
EnumGameGoal = Enum({QUICK = 1, STANDARD = 2,})

---@class EnumBPStrategy
---@field FREE number
---@field STANDARD number
---@operator call(number):boolean
EnumBPStrategy = Enum({FREE = 1, STANDARD = 2})