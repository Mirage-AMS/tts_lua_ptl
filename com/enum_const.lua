require("com/enum")

---@class DevMode
---@field Development number
---@field Guest number
DevMode = Enum(
    {
        Development = 1,
        Guest = 2,
    }
)
