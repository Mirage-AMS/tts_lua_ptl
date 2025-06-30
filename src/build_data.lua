require("com/const")
require("com/basic")
require("com/vector")

local function processZoneType(data, paramTemplate, paramData, zoneName, slotType, isPatternBased, refGuid)
    -- processZoneType辅助函数：处理单一区域类型的数据
    -- -- data: 存储构建后的区域数据
    -- -- paramTemplate: 参数模板
    -- -- paramData: 参数数据
    -- -- zoneName: 区域名称
    -- -- slotType: 槽位类型
    -- -- isPatternBased: 是否基于模式构建区域
    -- -- refGuid: 区域参照物Guid

    -- quick break if no zone config is found for this type
    if not paramData[zoneName] then return end
    -- quick break if no zone config is found for this type
    local zoneConfig = paramData[zoneName][slotType]
    if not zoneConfig then return end

    local slotTypePatternReflect = {
        [KEYWORD_ZONE_DECK] = nil,
        [KEYWORD_ZONE_DISCARD] = nil,
        [KEYWORD_ZONE_DISPLAY] = KEYWORD_ZONE_DISPLAY_PATTERN,
        [KEYWORD_ZONE_TOP] = KEYWORD_ZONE_TOP_PATTERN,
    }

    if isPatternBased then
        data[zoneName][slotType] = {}
        local patternKwd = slotTypePatternReflect[slotType]
        local pattern = paramData[zoneName][patternKwd]
        pattern = pattern or {x_num = 1, z_num = 1, x_shift = 0, z_shift = 0}
        for idx = 1, pattern.x_num do
            for idz = 1, pattern.z_num do
                local template = mergeTable(deepCopy(paramTemplate), zoneConfig)
                local shift = vectorAdd(
                  vectorScalarMultiply(pattern.x_shift, idx-1),
                  vectorScalarMultiply(pattern.z_shift, idz-1)
                )
                template.position = vectorAdd(template.position, shift)
                table.insert(data[zoneName][slotType], {ref = refGuid, param = template})
            end
        end
    else
        data[zoneName][slotType] = {
            ref = refGuid,
            param = mergeTable(deepCopy(paramTemplate), zoneConfig)
        }
    end
end


local function buildItemZoneData(data, paramTemplate, paramData, zoneNameList, refGuid)
    -- 区域数据构建函数
    -- -- data: 存储构建后的区域数据
    -- -- paramTemplate: 参数模板
    -- -- paramData: 参数数据
    -- -- zoneNameList: 区域名称列表
    -- -- refGuid: 区域参照物Guid
    for _, zoneName in ipairs(zoneNameList) do
        data[zoneName] = { name = zoneName }

        -- 处理非模式区域
        for _, slotType in ipairs({KEYWORD_ZONE_DECK, KEYWORD_ZONE_DISCARD}) do
            processZoneType(data, paramTemplate, paramData, zoneName, slotType,false, refGuid)
        end

        -- 处理模式区域
        for _, slotType in ipairs({KEYWORD_ZONE_DISPLAY, KEYWORD_ZONE_TOP}) do
            processZoneType(data, paramTemplate, paramData, zoneName, slotType,true, refGuid)
        end
    end
    return data
end

function buildDefaultData()
    local playerData = {}
    for _, playerColor in ipairs(DEFAULT_PLAYER_COLOR_LIST) do
        playerData[playerColor] = {
            item_manager = {
                containers = {},
                boards = { [NAME_BOARD_ROLE] = { guid = GUID_ROLE_BOARD_LIST[playerColor] } },
                zones = buildItemZoneData(
                    {},
                    PARAM_SCRIPTING_TRIGGER_PLAYER_DEFAULT,
                    LIST_PARAM_SCRIPING_TRIGGER_PLAYER,
                    PLAYER_ZONE_NAME_LIST,
                    GUID_ROLE_BOARD_LIST[playerColor]
                )
            }
        }
    end

    -- 构建默认数据，包括玩家、公共物品管理器等
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
                boards = { [NAME_BOARD_MAIN] = { guid = GUID_MAIN_BOARD } },
                zones = buildItemZoneData(
                    {},
                    PARAM_SCRIPTING_TRIGGER_DEFAULT,
                    LIST_PARAM_SCRIPING_TRIGGER,
                    PUBLIC_ZONE_NAME_LIST,
                    GUID_MAIN_BOARD)
            },
        },
        player_service = {
            players = playerData
        }
    }

    -- 返回构建后的默认数据
    return data
end

-- local a = buildDefaultData()
-- print(tableToString(a))