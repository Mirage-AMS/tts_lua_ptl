function Enum(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function()
            error("Enum is read-only", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end