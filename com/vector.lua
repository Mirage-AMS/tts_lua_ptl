require("mock/default")

---@param p0 Vector: pattern origin
---@param idx number: index in x-axis
---@param idz number: index in z-axis
---@param dx number: delta x
---@param dz number: delta z
---@return Vector position:
function getOffsetPosition(p0, idx, idz, dx, dz)
    if dx == 1 and dz == 1 then
        return p0
    end
    return p0 + Vector(idx * (dx - 1), 0, idz * (dz - 1))
end
