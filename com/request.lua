require("mock/default")
require("com/enum")
require("com/json")

---@class RequestMethodEnum
---@field DELETE string
---@field GET string
---@field HEAD string
---@field POST string
---@field PUT string
---@field __call(string): boolean
EnumRequestMethod = Enum({
    DELETE = "DELETE",
    GET = "GET",
    HEAD = "HEAD",
    POST = "POST",
    PUT = "PUT"
})

---@class Request
---@field __call(self): Request
---@field isRequest fun(v: any): boolean
---@field __type string
---@field url string
---@field method string
---@field headers table
---@field data table
---@field body table
---@field handler fun(request: WebRequestInstance)
---@field setHeader fun(self: Request, key: string, value: any): Request
---@field setHeaders fun(self: Request, headers: table<string, any>): Request
---@field setData fun(self: Request, data: table): Request
---@field setBody fun(self: Request, body: any): Request
---@field setHandler fun(self: Request, handler: fun(request: WebRequestInstance)): Request
---@field send fun(self: Request): Request
---@field handleResponse fun(self: Request, response: WebRequestInstance)
---@field get fun(self: Request, url: string, callback: fun(request: WebRequestInstance)): Request
---@field post fun(self: Request, url: string, data: table, callback: fun(request: WebRequestInstance)): Request

---@type table<string, any> RequestMethodTable
local RequestMethodTable = {
    __type = "Request",
    setUrl = function(self, url)
        if type(url) == "string" then
            self.url = url
        else
            print("Warning: url must be a string, got " .. type(url))
        end
        return self
    end,
    setMethod = function(self, method)
        if EnumRequestMethod(method) then
            self.method = method
        else
            print("Warning: method must be one of DELETE, GET, HEAD, POST, PUT")
        end
        return self
    end,
    -- 设置请求头
    setHeader = function(self, key, value)
        if type(key) == "string" then
            self.headers[key] = value
        end
        return self
    end,
    -- 设置多个请求头
    setHeaders = function(self, headers)
        for key, value in pairs(headers) do
            self:setHeader(key, value)
        end
        return self
    end,
    -- 设置请求数据（会触发后续的自动JSON编码）
    setData = function(self, data)
        self.data = data
        if data and not self.headers["Content-Type"] then
            self:setHeader("Content-Type", "application/json")
        end
        return self
    end,
    -- 直接设置请求体（不会触发JSON编码）
    setBody = function(self, body)
        self.body = body
        return self
    end,
    setHandler = function(self, handler)
        self.handler = handler
        return self
    end,
    send = function(self)
        -- 校验 url
        if type(self.url) ~= "string" or self.url == "" then
            error("Request url is invalid (must be a non-empty string)")
        end
        -- 校验 method
        if not EnumRequestMethod(self.method) then
            error("Request method is invalid (must be one of: DELETE, GET, HEAD, POST, PUT)")
        end

        if self.data and not self.body then
            self.body = Json.encode(self.data)        -- 如果设置了data但没有设置body，则自动编码data为JSON
        end

        if (self.method == EnumRequestMethod.POST or self.method == EnumRequestMethod.PUT)
           and not self.headers["Content-Type"] then
            self.headers["Content-Type"] = "application/x-www-form-urlencoded"  -- 如果是POST等有请求体的方法且未设置Content-Type，设置默认值
        end

        if not self.headers["Accept"] then
            self.headers["Accept"] = "application/json"         -- 如果期望JSON响应且未设置Accept头，自动设置
        end

        WebRequest.custom(
            self.url,
            self.method,
            false,
            self.body,
            self.headers,
            function(response)
                self:handleResponse(response)
            end
        )
        return self
    end,
    --- 处理响应函数, 主要封装一些错误处理
    ---@param self Request
    ---@param request WebRequestInstance
    handleResponse = function(self, request)
        if request.is_error then
            print("Error: " .. request.error)
            return
        end
        ---@TODO: 后续可以封装一些错误处理逻辑，例如重试机制等
        if self.handler ~= nil then
            self.handler(request)
        end
    end,
    --- 快捷发起GET请求
    get = function(self, url, callback)
        return self:setUrl(url)
                   :setMethod(EnumRequestMethod.GET)
                   :setHandler(callback)
                   :send()
    end,
    --- 快捷发起POST请求
    post = function(self, url, data, callback)
        return self:setUrl(url)
                   :setMethod(EnumRequestMethod.POST)
                   :setData(data)
                   :setHandler(callback)
                   :send()
    end,
}

-- 设置元表的__index指向自身
RequestMethodTable.__index = RequestMethodTable

-- 定义Request类表
Request = {}

--- Request 构造函数
---@return Request
function Request.new()
    local self = {
        url = "",                             -- 初始化 url 为空字符串
        method = EnumRequestMethod.GET,       -- 初始化 method 为 GET 方法
        headers = {},                         -- 初始化 headers 为空表（关键修复）
        data = nil,
        body = nil,
        handler = nil
    }
    setmetatable(self, RequestMethodTable)
    ---@cast self Request
    return self
end

function Request.isRequest(v)
    return type(v) == "table" and getmetatable(v) and getmetatable(v).__type == "Request"
end

setmetatable(Request,{
    __call = function(self)
        return self.new()
    end,
})
