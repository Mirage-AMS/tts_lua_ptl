function Enum(t)
    local proxy = {}
    local values = {}

    for _, v in pairs(t) do
        values[v] = true
    end

    local mt = {
        __index = t,
        __newindex = function()
            error("Enum is read-only", 2)
        end,
        __call = function(_, value)
            return values[value] ~= nil
        end
    }
    setmetatable(proxy, mt)
    return proxy
end