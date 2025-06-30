function vectorAdd(v1, v2)
    v1 = v1 or {x = 0, y = 0, z = 0}  -- Set default value if v1 is nil
    v2 = v2 or {x = 0, y = 0, z = 0}  -- Set default value if v2 is nil
    return {x = v1.x + v2.x, y = v1.y + v2.y, z = v1.z + v2.z}
end

function vectorScalarMultiply(v, scalar)
    v = v or {x = 0, y = 0, z = 0}  -- Set default value if v is nil
    return {x = v.x * scalar, y = v.y * scalar, z = v.z * scalar}
end
