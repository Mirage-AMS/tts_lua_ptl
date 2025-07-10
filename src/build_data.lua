require("com/const")
require("com/const_dev_board")
require("com/basic")
require("com/vector")
require("com/enum_const")


--- 处理单一区域类型的数据
---@param zoneData table: 存储构建后的区域数据（单个区域）
---@param paramTemplate table: 参数模板
---@param paramData table: 参数数据
---@param slotType string: 槽位类型
---@param isPatternBased boolean: 是否基于模式构建区域
---@param refGuid string: 区域参照物Guid
local function processZoneType(zoneData, paramTemplate, paramData, slotType, isPatternBased, refGuid)
    -- quick break if no zone config is found for this type
    local zoneConfig = paramData[zoneData.name] and paramData[zoneData.name][slotType]
    if not zoneConfig then return end

    local slotTypePatternReflect = {
        [KEYWORD_ZONE_DECK] = nil,
        [KEYWORD_ZONE_DISCARD] = nil,
        [KEYWORD_ZONE_DISPLAY] = KEYWORD_ZONE_DISPLAY_PATTERN,
        [KEYWORD_ZONE_TOP] = KEYWORD_ZONE_TOP_PATTERN,
    }

    if isPatternBased then
        zoneData[slotType] = {}
        local patternKwd = slotTypePatternReflect[slotType]
        local pattern = paramData[zoneData.name][patternKwd]
        pattern = pattern or {x_num = 1, z_num = 1, x_shift = 0, z_shift = 0}
        for idz = 1, pattern.z_num do
            for idx = 1, pattern.x_num do
                local template = mergeTable(deepCopy(paramTemplate), zoneConfig)
                local templatePos = Vector(template.position)
                template.position = getOffsetPosition(templatePos, idx, idz, pattern.x_shift, pattern.z_shift)
                table.insert(zoneData[slotType], {ref = refGuid, param = template})
            end
        end
    else
        zoneData[slotType] = {
            ref = refGuid,
            param = mergeTable(deepCopy(paramTemplate), zoneConfig)
        }
    end
end

--- 区域数据构建函数
---@param data table: 存储构建后的区域数据
---@param paramTemplate table: 参数模板
---@param paramData table: 参数数据
---@param zoneNameList table: 区域名称列表
---@param refGuid string: 区域参照物Guid
local function buildItemZoneData(data, paramTemplate, paramData, zoneNameList, refGuid)
    for _, zoneName in ipairs(zoneNameList) do
        data[zoneName] = { name = zoneName }
        local zoneData = data[zoneName]

        -- 处理非模式区域
        for _, slotType in ipairs({KEYWORD_ZONE_DECK, KEYWORD_ZONE_DISCARD}) do
            processZoneType(zoneData, paramTemplate, paramData, slotType, false, refGuid)
        end

        -- 处理模式区域
        for _, slotType in ipairs({KEYWORD_ZONE_DISPLAY, KEYWORD_ZONE_TOP}) do
            processZoneType(zoneData, paramTemplate, paramData, slotType, true, refGuid)
        end
    end
    return data
end


--- 构建玩家数据
local function buildPlayerData()
    local playerList = DEFAULT_PLAYER_COLOR_LIST
    local paramTemplate = PARAM_SCRIPTING_TRIGGER_PLAYER_DEFAULT
    local paramData = LIST_PARAM_SCRIPING_TRIGGER_PLAYER
    local zoneNameList = PLAYER_ZONE_NAME_LIST

    local playerData = {}
    for _, playerColor in ipairs(playerList) do
        local roleBoardGuid = GUID_ROLE_BOARD_LIST[playerColor]
        playerData[playerColor] = {
            item_manager = {
                containers = {},
                boards = { [NAME_BOARD_ROLE] = { guid = roleBoardGuid } },
                zones = buildItemZoneData({}, paramTemplate, paramData, zoneNameList,roleBoardGuid)
            }
        }
    end

    return playerData
end

--- 构建公共区域数据
function buildPublicZoneData()
    local data, paramTemplate, paramData, zoneNameList, refGuid

    data = {}
    paramTemplate = PARAM_SCRIPTING_TRIGGER_DEFAULT

    -- mo/fo/du/ma/co zone
    paramData = LIST_PARAM_SCRIPING_TRIGGER
    zoneNameList = PUBLIC_ZONE_NAME_LIST
    refGuid = GUID_MAIN_BOARD
    data = buildItemZoneData(data, paramTemplate, paramData, zoneNameList, refGuid)

    -- role-pick zone
    paramData = LIST_PARAM_SCRIPTING_ROLE_PICK
    zoneNameList = {NAME_ZONE_ROLE_PICK}
    refGuid = GUID_MAIN_BOARD
    data = buildItemZoneData(data, paramTemplate, paramData, zoneNameList, refGuid)

    -- display role part
    -- TODO: pending...

    -- development zone
    paramData = LIST_PARAM_SCRIPTING_DEV_MODE
    zoneNameList = {NAME_ZONE_DEVELOPMENT}
    refGuid = GUID_DEV_BOARD
    data = buildItemZoneData(data, paramTemplate, paramData, zoneNameList, refGuid)

    return data
end


--- 构建默认数据
function buildDefaultData()
    local data =  {
        version = SCRIPT_VERSION,
        public_service = {
            turn_manager = {
                first_player = nil,
                current_player = nil,
                round = 0,
                state = 0,
            },
            item_manager = {
                containers = { [NAME_RUBBISH_BIN] = {guid = GUID_RUBBISH_BIN }},
                boards = {
                    [NAME_BOARD_MAIN] = { guid = GUID_MAIN_BOARD },
                    [NAME_GAME_BOARD] = { guid = GUID_GAME_BOARD },
                    [NAME_BOARD_DEVELOPMENT] = { guid = GUID_DEV_BOARD },
                    [NAME_BOARD_ROLE_DISPLAY_01] = { guid = GUID_ROLE_DISPLAY_BOARD_01 },
                    [NAME_BOARD_ROLE_DISPLAY_02] = { guid = GUID_ROLE_DISPLAY_BOARD_02 },
                    [NAME_BOARD_ROLE_DISPLAY_03] = { guid = GUID_ROLE_DISPLAY_BOARD_03 },
                    [NAME_BOARD_ROLE_DISPLAY_04] = { guid = GUID_ROLE_DISPLAY_BOARD_04 },
                },
                zones = buildPublicZoneData()
            },
            mode_manager = {
                dev_mode = DevMode.Development, -- 默认模式为开发模式
            }
        },
        player_service = {
            players = buildPlayerData()
        }
    }

    -- 返回构建后的默认数据
    return data
end

-- local a = buildDefaultData()
-- print(tableToString(a))