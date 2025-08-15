require("mock/default")
require("com/enum")
require("com/json")
require("com/basic")

---@class EnumRequestMethod
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

---@class EnumRequestStatus
---@field UNKNOWN number
---@field SUCCESS number
---@field NOT_MODIFIED number
---@field BAD_REQUEST number
---@field UNAUTHORIZED number
---@field FORBIDDEN number
---@field NOT_FOUND number
---@field METHOD_NOT_ALLOWED number
---@field TOO_MANY_REQUESTS number
---@field INTERNAL_SERVER_ERROR number
---@field BAD_GATEWAY number
---@field SERVICE_UNAVAILABLE number
---@field GATEWAY_TIMEOUT number
EnumRequestStatus = Enum({
    UNKNOWN = -1,
    SUCCESS = 200,
    NOT_MODIFIED = 304,
    BAD_REQUEST = 400,
    UNAUTHORIZED = 401,
    FORBIDDEN = 403,
    NOT_FOUND = 404,
    METHOD_NOT_ALLOWED = 405,
    TOO_MANY_REQUESTS = 429,
    INTERNAL_SERVER_ERROR = 500,
    BAD_GATEWAY = 502,
    SERVICE_UNAVAILABLE = 503,
    GATEWAY_TIMEOUT = 504,
})

---@class Request
---@field __call(self): Request
---@field isRequest fun(v: any): boolean
---@field __type string
---@field __max_delay number
---@field __retry_strategy table<number, boolean>
---@field url string
---@field method string
---@field headers table
---@field data table
---@field body table
---@field handler fun(request: WebRequestInstance)
---@field max_retry_count number
---@field retry_delay number
---@field retry_count number
---@field setUrl fun(self: Request, url: string): Request
---@field setMethod fun(self: Request, method: string): Request
---@field setHeader fun(self: Request, key: string, value: any): Request
---@field setHeaders fun(self: Request, headers: table<string, any>): Request
---@field setData fun(self: Request, data: table): Request
---@field setBody fun(self: Request, body: any): Request
---@field setHandler fun(self: Request, handler: fun(request: WebRequestInstance)?): Request
---@field setMaxRetryCount fun(self: Request, max_retry_count: number): Request
---@field setRetryDelay fun(self: Request, retry_delay: number): Request
---@field setRetryCount fun(self: Request, retry_count: number): Request
---@field clone fun(self: Request): Request
---@field retry fun(self: Request, delay: number?)
---@field send fun(self: Request): Request
---@field handleResponse fun(self: Request, response: WebRequestInstance)
---@field get fun(self: Request, url: string, callback: fun(request: WebRequestInstance)): Request
---@field post fun(self: Request, url: string, data: table, callback: fun(request: WebRequestInstance)): Request

---@type table<string, any> RequestMethodTable
local RequestMethodTable = {
    __type = "Request",
    __max_delay = 10,
    __retry_strategy = {
        [EnumRequestStatus.UNKNOWN] = true,
        [EnumRequestStatus.SUCCESS] = false,
        [EnumRequestStatus.NOT_MODIFIED] = false,
        [EnumRequestStatus.BAD_REQUEST] = false,
        [EnumRequestStatus.UNAUTHORIZED] = false,
        [EnumRequestStatus.FORBIDDEN] = false,
        [EnumRequestStatus.NOT_FOUND] = false,
        [EnumRequestStatus.METHOD_NOT_ALLOWED] = false,
        [EnumRequestStatus.TOO_MANY_REQUESTS] = true,
        [EnumRequestStatus.INTERNAL_SERVER_ERROR] = true,
        [EnumRequestStatus.BAD_GATEWAY] = true,
        [EnumRequestStatus.SERVICE_UNAVAILABLE] = true,
        [EnumRequestStatus.GATEWAY_TIMEOUT] = true,
    },
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
    -- setData 优化：data 为 nil 时清除自动添加的 Content-Type
    setData = function(self, data)
        self.data = data
        -- 若 data 为 nil，清除自动设置的 JSON Content-Type
        if not data then
            if self.headers["Content-Type"] == "application/json" then
                self.headers["Content-Type"] = nil
            end
        elseif not self.headers["Content-Type"] then
            -- 仅在 data 存在且无 Content-Type 时自动设置
            self:setHeader("Content-Type", "application/json")
        end
        return self
    end,
    -- 直接设置请求体（不会触发JSON编码）
    setBody = function(self, body)
        self.body = body
        self.data = nil  -- 显式清除 data，避免冲突
        return self
    end,
    setHandler = function(self, handler)
        if handler and type(handler) == "function" then
            self.handler = handler
        end
        return self
    end,
    -- 设置最大重试次数
    setMaxRetryCount = function(self, max_retry_count)
        if type(max_retry_count) == "number" and max_retry_count >= 0 then
            self.max_retry_count = max_retry_count
        end
        return self
    end,
    -- 设置重试间隔
    setRetryDelay = function(self, retry_delay)
        if type(retry_delay) == "number" and retry_delay >= 0 then
            self.retry_delay = retry_delay
        end
        return self
    end,
    -- 设置当前重试次数
    setRetryCount = function(self, retry_count)
        if type(retry_count) == "number" and retry_count >= 0 then
            self.retry_count = retry_count
        end
        return self
    end,
    clone = function(self)
        local newRequest = Request()
            :setUrl(self.url)
            :setMethod(self.method)
            :setHeaders(deepCopy(self.headers))
            :setData(self.data)
            :setBody(self.body)
            :setHandler(self.handler)
            :setMaxRetryCount(self.max_retry_count)
            :setRetryDelay(self.retry_delay)
            :setRetryCount(self.retry_count)
        return newRequest
    end,
    retry = function(self, delay)
        local baseDelay = (self.retry_delay or 1) * (2 ^ self.retry_count)  -- 默认1秒为基础
        if delay and type(delay) == "number" and delay > 0 then
            baseDelay = delay
        end
        local jitter = math.random() * 0.5 * baseDelay  -- 0~50%的随机延迟
        local retryDelay = math.min(baseDelay + jitter, self.__max_delay)

        local newRequest = self:clone()
            :setRetryCount(self.retry_count + 1)

        Wait.time(
            function()
                print(string.format("Retrying request (url: %s) - attempt %d", newRequest.url, newRequest.retry_count))
                newRequest:send()
            end,
            retryDelay
        )
    end,
    send = function(self)
        -- 校验 url
        if type(self.url) ~= "string" or self.url == "" then
            print("Error: Request url is invalid (must be a non-empty string)")
            return self  -- 返回 self 维持链式调用
        end
        -- 校验 method
        if not EnumRequestMethod(self.method) then
            print("Error: Request method is invalid (must be one of: be one of DELETE, GET, HEAD, POST, PUT)")
            return self
        end

        if self.data and not self.body then
            local success, encoded = pcall(Json.encode, self.data)
            if not success then
                print("Error: Failed to encode data to JSON - " .. encoded)
                return self  -- 终止请求发送
            end
            self.body = encoded
        end

        local hasContentType = self.headers["Content-Type"] ~= nil
        if (self.method == EnumRequestMethod.POST or self.method == EnumRequestMethod.PUT) and not hasContentType then
            self.headers["Content-Type"] = "application/x-www-form-urlencoded"
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
    ---@param response WebRequestInstance
    handleResponse = function(self, response)
        --- Successful Response Handler (response code 200-299)
        if response and not response.is_error and (
            response.response_code >= 200 and response.response_code < 300
        ) then
            if self.handler ~= nil then
                self.handler(response)
            end
            return
        end

        --- Error Response Handler
        local statusCode = response and response.response_code or EnumRequestStatus.UNKNOWN
        if not response or response.is_error then
            local errMsg = response and ("error: " .. (response.error or "unknown error")) or "request is nil"
            print(string.format("Request failed (url: %s, code: %d): %s", self.url, statusCode, errMsg))
        end

        --- Retry Strategy
        local isRetry = self.__retry_strategy[statusCode] == true and self.retry_count < self.max_retry_count
        if isRetry then
            local retryAfter = response and response.getResponseHeader("Retry-After") or nil
            local retryDelay = tonumber(retryAfter)
            self:retry(retryDelay)
        else
            print(string.format("Request failed after %d retries (url: %s, code: %d)",
                self.max_retry_count, self.url, statusCode))
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
        handler = nil,
        max_retry_count = 3,
        retry_delay = 1,
        retry_count = 0,
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
