---@class Vector
---@field __index table 向量类的方法表
---@field __type string 向量类类型标识
---@field __isVector fun(v: any): boolean 内部函数，判断是否是向量
---@field x number 向量x分量
---@field y number 向量y分量
---@field z number 向量z分量
---@field __call fun(self: Vector, x?: number|table, y?: number, z?: number): Vector 调用类创建新实例
---@field new fun(self: Vector, x?: number|table, y?: number, z?: number): Vector 构造新向量
---@field __add fun(self: Vector, a: Vector): Vector 向量加法
---@field __sub fun(self: Vector, a: Vector): Vector 向量减法
---@field __mul fun(self: Vector, a: number): Vector 向量×标量
---@field __mul fun(self: Vector, a: Vector): number 向量点积

-- 定义向量类的元表，包含所有公共方法
local VectorMetatable = {
    -- 类型标识
    __type = "Vector",
    -- 向量加法
    __add = function(self, other)
        if not Vector.isVector(other) then
            error("加法运算不支持的参数类型: " .. type(other))
        end
        return Vector(self.x + other.x, self.y + other.y, self.z + other.z)
    end,

    -- 向量减法
    __sub = function(self, other)
        if not Vector.isVector(other) then
            error("减法运算不支持的参数类型: " .. type(other))
        end
        return Vector(self.x - other.x, self.y - other.y, self.z - other.z)
    end,

    -- 向量点积
    dot = function(self, other)
        return self.x * other.x + self.y * other.y + self.z * other.z
    end,

    -- 向量×标量或向量点积（重载）
    __mul = function(self, other)
        -- 检查参数类型，区分运算类型
        if type(other) == "number" then
            -- 场景1：向量 × 标量（返回新向量）
            return Vector(
                self.x * other,
                self.y * other,
                self.z * other
            )
        elseif Vector.isVector(other) then
            -- 场景2：向量 × 向量（返回点积，数字类型）
            return self.x * other.x + self.y * other.y + self.z * other.z
        else
            -- 不支持的运算类型，抛出错误
            error("乘法运算不支持的参数类型: " .. type(other))
        end
    end,

    -- 向量长度
    length = function(self)
        return math.sqrt(self:dot(self))
    end,

    -- 向量归一化
    normalize = function(self)
        local len = self:length()
        if len > 0 then
            return self * (1 / len)
        end
        return Vector()
    end,

    -- 重写__tostring方法，方便打印
    __tostring = function(self)
        return string.format("Vector(%.2f, %.2f, %.2f)", self.x, self.y, self.z)
    end
}

-- 设置元表的__index，指向自身（确保方法查找能正常工作）
--__index 必须放在元表里才有意义，放在实例自身中只是一个普通键值对，不会影响 Lua 的字段查找行为。
VectorMetatable.__index = VectorMetatable

-- 定义Vector类表
Vector = {}

--- Vector 构造函数
---@param x number|table 向量的x分量，或包含x,y,z的分量表
---@param y number 向量的y分量
---@param z number 向量的z分量
---@return Vector ret 返回新创建的向量实例
function Vector.new(x, y, z)
    -- 如果x是table，从table中提取分量
    if type(x) == "table" then return Vector.new(x.x, x.y, x.z) end
    -- 创建实例，设置分量
    local self = {
        x = x or 0,
        y = y or 0,
        z = z or 0
    }
    -- 为实例设置元表，使其继承所有公共方法（通过元表继承）, 但不继承类表方法(isVector, new & __call)
    setmetatable(self, VectorMetatable)
    ---@cast self Vector
    return self
end

---Vector 类型检查函数
---@param v any 任意值
---@return boolean ret 是否为向量实例
function Vector.isVector(v)
    return type(v) == "table" and getmetatable(v) and getmetatable(v).__type == "Vector"
end

-- 允许直接通过Vector(...)进行实例化
setmetatable(Vector, {
    -- 因为Vector是一个表，当你像函数一样调用它（Vector(a,b,c)）时，Lua 会检查Vector的元表，
    -- 发现其中定义了__call元方法，于是执行该方法。
    __call = function(cls, x, y, z)
        return cls.new(x, y, z)
    end
})

