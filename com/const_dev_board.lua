require("mock/default")
require("com/const")

-- DECKS CONST
PREFIX_MO_STD01 = "MO_STD01"
PREFIX_FO_STD01 = "FO_STD01"
PREFIX_DU_STD01 = "DU_STD01"
PREFIX_MA_STD01 = "MA_STD01"
PREFIX_MA_DLC01 = "MA_DLC01"
PREFIX_CO_STD01 = "CO_STD01"
PREFIX_CO_STD02 = "CO_STD02"
PREFIX_CO_DLC01 = "CO_DLC01"
PREFIX_RO_INT01 = "RO_INT01"
PREFIX_RO_INT02 = "RO_INT02"
PREFIX_RO_INF01 = "RO_INF01"
PREFIX_RO_INF02 = "RO_INF02"
PREFIX_LG_STD01 = "LG_STD01"
PREFIX_AC_STD01 = "AC_STD01"

DECK_LIST = {
    PREFIX_MO_STD01, PREFIX_FO_STD01, PREFIX_DU_STD01,
    PREFIX_MA_STD01, PREFIX_MA_DLC01,
    PREFIX_CO_STD01, PREFIX_CO_STD02, PREFIX_CO_DLC01,
    PREFIX_RO_INT01, PREFIX_RO_INT02,
    PREFIX_RO_INF01, PREFIX_RO_INF02,
    PREFIX_LG_STD01, PREFIX_AC_STD01,
}

DECK_INFO = {
    -- Exploration ----------------------------------------------------
    [PREFIX_MO_STD01] = {
        "黄铁","黄铁","黄铁","水晶","水晶","水晶",
        "硫磺","硫磺","硫磺","黄铜","黄铜","石榴石",
        "石榴石","朱砂","朱砂","矽卡岩","黑玛瑙","黑曜石",
        "欧米伽","女神之泪","荧光藓","野蓝莓","高山杜鹃","剑棘花",
        "熔炉之芯","熔岩蛞蝓","岩鼠","山羊","豺","苍鹰",
    },
    [PREFIX_FO_STD01] = {
        "草木百合","草木百合","草木百合","红伞菇","红伞菇","红伞菇",
        "槲寄生","槲寄生","槲寄生","沐光葵","沐光葵","箭毒木",
        "箭毒木","狭影荚","狭影荚","含笑花","尸生草","接骨木",
        "古树新芽","幻影花","闪锌矿","黄玉","石膏","陨铁",
        "翡翠","蜂巢","狐狸","黄鹿","云豹","凶虎",
    },
    [PREFIX_DU_STD01] = {
        "史莱姆","史莱姆","史莱姆","暗影猫","暗影猫","暗影猫",
        "盲蛇","盲蛇","盲蛇","元素精灵","元素精灵","恐狼",
        "恐狼","巨蜥","巨蜥","梦魇","奇美拉","狮鹫",
        "炎龙","不朽之誓·哈米尔","曼德拉草","魔芋","幽毒菇","食人花",
        "水月镜花","锈铁","绿松石","夜明石","刚玉","水银",
    },

    -- Market ---------------------------------------------------------
    [PREFIX_MA_STD01] = {
        "风信子","颠茄","薄荷","曼陀罗","罂粟果","罗勒",
        "锆石","紫水晶","橄榄石","秘银","猫眼石","黄金",
        "原牛","水蛇","狍子","棕熊","角鲨","鳄鱼",
        "讨价还价","清仓处理","稀缺资源","货品更换","圣水","转换魔药",
        "兴奋剂","铁铲","铁剪","短匕","精制皮甲","时之沙漏",
    },
    [PREFIX_MA_DLC01] = {
        "石叶草","结晶虫","叶尾蜥","紫晶藤","龙鲮","幽冥海葵",
        "囤积居奇","商业直觉","雇佣小队","遗忘魔药","工匠笔记","羊皮古卷",
        "探险笔记","采集机巧","化身假面",
    },

    -- Conventicle ----------------------------------------------------
    [PREFIX_CO_STD01] = {
        "情报购买","情报交换","隔墙有耳","不胫而走","酒桌谈资","道听途说",
        "林野见闻","病中偶得","金融投资","情报筛选","侦查小队","紧急行动",
        "躲避风头","通晓万物","命运骗徒","先遣军","猎杀行动","幕后主使",
        "矿镐","水晶灯","护身符","毒箭","占卜杖","营养液",
        "地图工具","矿工手套","专业套装","启示者","体魄药剂","洞察烟斗",
    },
    [PREFIX_CO_STD02] = {
        "泉涌魔药","骨爪魔杖","闪灵机关","幻景法杖","无影披风","一千零一夜",
        "地之震荡","山之共鸣","水之奔流","浪之激流","火之燎燃","炎之呼啸",
        "风之轻抚","气之波动","大地孕育","凝冰成器","火力全开","强袭飓风",
        "扭转乾坤","传送法阵","洪水审判","熔炉重塑","超越虚空","闪电霹雳",
        "彼端奇闻","沧海遗珠","赞助游说","独家秘闻","全城搜捕","全城封锁",
    },
    [PREFIX_CO_DLC01] = {
        "情报中介","后知后觉","荒野求生","非正规军","驯兽术","精华萃取",
        "厚积薄发","精益求精","恃强凌弱","智慧树","沙之书","专利文书",
        "奥术原理","双生魔杖","冥冥魔药","幻梦之茧","魔鬼之契","神谕密诏",
        "土之枯竭","雨之时节","灼之地带","岚之轻语","生命汲取","迅风快斩",
        "灵魂奇旅","灵识吞灭","点石成金","开业酬宾","元素洪流","魔力凝滞",
    },

    -- Role -----------------------------------------------------------
    [PREFIX_RO_INT01] = {
        "达维安，巨人杀手","盖尔曼，历战勇士","埃尔，铁与火","泽丽尔，树屋精灵","保罗与波娜，那对兄妹","凯瑟琳，完美主义",
        "希玛，狩魔不息","塔尔凡，漫游吟者","诺维，初生牛犊","夏洛克，独断专营","索兰，高山行者","菲莉斯，圣女垂怜"
    },
    [PREFIX_RO_INT02] = {
        "法师，王朝余烬","莱奥，命运之剑","艾尔弗里德，大展宏图","莱拉娜，丰饶祭祀","欧也妮，匠心独运","弗林特，栖身林原",
        "艾丽娅，驯鹰人","卡洛斯，万咒环身","凯，嗜赌成性",
    },
    [PREFIX_RO_INF01] = {
        "嗜血药剂","达维恩的巨人杀手","卓越战技：诱敌深入","卓越战技：决胜一击","金刚铸魂","激昂澎湃",
        "活力药剂","润物无声","波娜的记账簿","冰火轮舞","优雅之舞","风之华舞",
        "弑魔者","万象法咒","漫游灵药","冒险奇谭","冒险启程","勤能补拙",
        "货品退换","垄断经营","爆破专家","山脊眺望","圣泉赐福","圣女祝祷",
    },
    [PREFIX_RO_INF02] = {
        "魔咒闪回","瞬灭","试剑真知","剑心·浪游","剑心·勇武","剑心·统领",
        "执政手腕","令行禁止","丰饶祈愿","虔敬花冠","独具匠心","勒菲弗巧械铺",
        "林地作业","林中小屋","鹰舍邂逅","万咒法典","法术研习","老千惯犯",
        "连战连胜",
    },

    -- Legend ---------------------------------------------------------
    [PREFIX_LG_STD01] = {
        "传奇：扬名立万","传奇：富甲一方","传奇：登峰造极","传奇：扬名立万","传奇：富甲一方","传奇：掌控元素",
        "传奇：脱胎换骨",
    },

    -- Accessory ------------------------------------------------------
    [PREFIX_AC_STD01] = {
        "烂草","足金","赐福圣水",
    },
}


NAME_BOARD_DEVELOPMENT = "board_development"
NAME_BOARD_ROLE_DISPLAY_01 = "board_role_display_01"
NAME_BOARD_ROLE_DISPLAY_02 = "board_role_display_02"
NAME_BOARD_ROLE_DISPLAY_03 = "board_role_display_03"
NAME_BOARD_ROLE_DISPLAY_04 = "board_role_display_04"
BOARD_ROLE_DISPLAY_LIST = {
    [1] = NAME_BOARD_ROLE_DISPLAY_01,
    [2] = NAME_BOARD_ROLE_DISPLAY_02,
    [3] = NAME_BOARD_ROLE_DISPLAY_03,
    [4] = NAME_BOARD_ROLE_DISPLAY_04,
}

NAME_ZONE_DEVELOPMENT = "zone_development"
NAME_ZONE_ROLE_PICK = "zone_role_pick"

DEVELOPMENT_ZONE_DISPLAY_SLOT_SETUP = {
    -- 1st part
    [PREFIX_MO_STD01] = 1,
    [PREFIX_FO_STD01] = 2,
    [PREFIX_DU_STD01] = 3,
    -- 2nd part
    [PREFIX_MA_STD01] = 5,
    [PREFIX_MA_DLC01] = 6,
    -- 3nd part
    [PREFIX_CO_STD01] = 9,
    [PREFIX_CO_STD02] = 10,
    [PREFIX_CO_DLC01] = 11,
    -- 4rd part
    [PREFIX_RO_INT01] = 13,
    [PREFIX_RO_INT02] = 14,
    -- 5rd part
    [PREFIX_RO_INF01] = 17,
    [PREFIX_RO_INF02] = 18,
    -- 6th part
    [PREFIX_LG_STD01] = 21,
    [PREFIX_AC_STD01] = 22,
}

PARAM_DEV_BOARD_HEIGHT = 2.0

-- ref to main board (for player pick the role)
LIST_PARAM_SCRIPTING_ROLE_PICK = {
    [NAME_ZONE_ROLE_PICK] = {
        [KEYWORD_ZONE_DECK] = {
            position = {x=12.5, y=0.0, z=5.0,},
        }
    },
}

-- ref to dev board
LIST_PARAM_SCRIPTING_DEV_MODE = {
    [NAME_ZONE_DEVELOPMENT] = {
        [KEYWORD_ZONE_DISPLAY] = {
            position    = {x=-10, z=14.5, y=PARAM_DEV_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY_PATTERN] = {
            x_num=4, x_shift=4.9,
            z_num=6, z_shift=-5.60,
        },
    }
}

-- ref to certain role display board
LIST_PARAM_ROLE_DISPLAY = {
    [PREFIX_RO_INT01] = {
        [1] = {id = 1, idx = 1, idz = 3},  -- 达维安，巨人杀手
        [2] = {id = 1, idx = 2, idz = 1},  -- 盖尔曼，历战勇士
        [3] = {id = 1, idx = 2, idz = 2},  -- 埃尔，铁与火
        [4] = {id = 1, idx = 1, idz = 2},  -- 泽丽尔，树屋精灵
        [5] = {id = 2, idx = 1, idz = 2},  -- 保罗与波娜，那对兄妹
        [6] = {id = 2, idx = 2, idz = 1},  -- 凯瑟琳，完美主义
        [7] = {id = 1, idx = 2, idz = 3},  -- 希玛，狩魔不息
        [8] = {id = 2, idx = 2, idz = 3},  -- 塔尔凡，漫游吟者
        [9] = {id = 1, idx = 1, idz = 1},  -- 诺维，初生牛犊
        [10] = {id = 2, idx = 2, idz = 2},  -- 夏洛克，独断专营
        [11] = {id = 2, idx = 1, idz = 1},  -- 索兰，高山行者
        [12] = {id = 2, idx = 1, idz = 3},  -- 菲莉斯，圣女垂怜
    },
    [PREFIX_RO_INT02] = {
        [1] = {id = 3, idx = 1, idz = 1},  -- 法师，王朝余烬
        [2] = {id = 3, idx = 1, idz = 2},  -- 莱奥，命运之剑
        [3] = {id = 3, idx = 2, idz = 1},  -- 艾尔弗里德，大展宏图
        [4] = {id = 3, idx = 2, idz = 2},  -- 莱拉娜，丰饶祭祀
        [5] = {id = 3, idx = 1, idz = 3},  -- 欧也妮，匠心独运
        [6] = {id = 3, idx = 2, idz = 3},  -- 弗林特，栖身林原
        [7] = {id = 4, idx = 1, idz = 1},  -- 艾丽娅，驯鹰人
        [8] = {id = 4, idx = 2, idz = 1},  -- 卡洛斯，万咒环身
        [9] = {id = 4, idx = 1, idz = 2},  -- 凯，嗜赌成性
    },
    [PREFIX_RO_INF01] = {
        [1] = {id = 1, idx = 1, idz = 3, idxx = 2, idzz = 1},  -- 嗜血药剂
        [2] = {id = 1, idx = 1, idz = 3, idxx = 3, idzz = 1},  -- 达维恩的巨人杀手
        [3] = {id = 1, idx = 2, idz = 1, idxx = 2, idzz = 1},  -- 卓越战技：诱敌深入
        [4] = {id = 1, idx = 2, idz = 1, idxx = 3, idzz = 1},  -- 卓越战绩：决胜一击
        [5] = {id = 1, idx = 2, idz = 2, idxx = 2, idzz = 1},  -- 金刚铸魂
        [6] = {id = 1, idx = 2, idz = 2, idxx = 3, idzz = 1},  -- 激昂澎湃
        [7] = {id = 1, idx = 1, idz = 2, idxx = 2, idzz = 1},  -- 活力药剂
        [8] = {id = 1, idx = 1, idz = 2, idxx = 3, idzz = 1},  -- 润物无声
        [9] = {id = 2, idx = 1, idz = 2, idxx = 2, idzz = 1},  -- 波娜的记账簿
        [10] = {id = 2, idx = 1, idz = 2, idxx = 3, idzz = 1},  -- 冰火轮舞
        [11] = {id = 2, idx = 2, idz = 1, idxx = 3, idzz = 1},  -- 优雅之舞
        [12] = {id = 2, idx = 2, idz = 1, idxx = 2, idzz = 1},  -- 风之华舞
        [13] = {id = 1, idx = 2, idz = 3, idxx = 2, idzz = 1},  -- 弑魔者
        [14] = {id = 1, idx = 2, idz = 3, idxx = 3, idzz = 1},  -- 万象法咒
        [15] = {id = 2, idx = 2, idz = 3, idxx = 2, idzz = 1},  -- 漫游灵药
        [16] = {id = 2, idx = 2, idz = 3, idxx = 3, idzz = 1},  -- 冒险奇谭
        [17] = {id = 1, idx = 1, idz = 1, idxx = 2, idzz = 1},  -- 冒险启程
        [18] = {id = 1, idx = 1, idz = 1, idxx = 3, idzz = 1},  -- 勤能补拙
        [19] = {id = 2, idx = 2, idz = 2, idxx = 2, idzz = 1},  -- 货品退换
        [20] = {id = 2, idx = 2, idz = 2, idxx = 3, idzz = 1},  -- 垄断经营
        [21] = {id = 2, idx = 1, idz = 1, idxx = 2, idzz = 1},  -- 爆破专家
        [22] = {id = 2, idx = 1, idz = 1, idxx = 3, idzz = 1},  -- 山脊眺望
        [23] = {id = 2, idx = 1, idz = 3, idxx = 2, idzz = 1},  -- 圣泉赐福
        [24] = {id = 2, idx = 1, idz = 3, idxx = 3, idzz = 1},  -- 圣女祝祷
    },
    [PREFIX_RO_INF02] = {
        [1]  = {id = 3, idx = 1, idz = 1, idxx = 2, idzz = 1},  -- 魔咒闪回
        [2]  = {id = 3, idx = 1, idz = 1, idxx = 3, idzz = 1},  -- 瞬灭
        [3]  = {id = 3, idx = 1, idz = 2, idxx = 2, idzz = 1},  -- 试剑真知
        [4]  = {id = 3, idx = 1, idz = 2, idxx = 3, idzz = 1, idxxx = 1, idzzz = 1},  -- 剑心·浪游
        [5]  = {id = 3, idx = 1, idz = 2, idxx = 3, idzz = 1, idxxx = 2, idzzz = 1},  -- 剑心·勇武
        [6]  = {id = 3, idx = 1, idz = 2, idxx = 3, idzz = 1, idxxx = 3, idzzz = 1},  -- 剑心·统领
        [7]  = {id = 3, idx = 2, idz = 1, idxx = 2, idzz = 1},  -- 执政手腕
        [8]  = {id = 3, idx = 2, idz = 1, idxx = 3, idzz = 1},  -- 令行禁止
        [9]  = {id = 3, idx = 2, idz = 2, idxx = 2, idzz = 1},  -- 丰饶祈愿
        [10] = {id = 3, idx = 2, idz = 2, idxx = 3, idzz = 1},  -- 虔敬花冠
        [11] = {id = 3, idx = 1, idz = 3, idxx = 2, idzz = 1},  -- 独具匠心
        [12] = {id = 3, idx = 1, idz = 3, idxx = 3, idzz = 1},  -- 勒菲弗巧械铺
        [13] = {id = 3, idx = 2, idz = 3, idxx = 2, idzz = 1},  -- 林地作业
        [14] = {id = 3, idx = 2, idz = 3, idxx = 3, idzz = 1},  -- 林中小屋
        [15] = {id = 4, idx = 1, idz = 1, idxx = 2, idzz = 1},  -- 鹰舍邂逅
        [16] = {id = 4, idx = 2, idz = 1, idxx = 2, idzz = 1},  -- 万咒法典
        [17] = {id = 4, idx = 2, idz = 1, idxx = 3, idzz = 1},  -- 法术研习
        [18] = {id = 4, idx = 1, idz = 2, idxx = 2, idzz = 1},  -- 老千惯犯
        [19] = {id = 4, idx = 1, idz = 2, idxx = 3, idzz = 1},  -- 连战连胜
    },
}

ROLE_DISPLAY_BOARD_PATTERN = {
    origin = Vector(-11.84, 0.20, 7.38),
    dx =  15.11, dz = -7.38,
    dxx = 4.3, dzz = 0.0,
    dxxx = 1.0, dzzz = 0.0,
}

-- VAR
GUID_DEV_BOARD = "877790"
GUID_ROLE_DISPLAY_BOARD_01 = "b97de7"
GUID_ROLE_DISPLAY_BOARD_02 = "fc8757"
GUID_ROLE_DISPLAY_BOARD_03 = "159497"
GUID_ROLE_DISPLAY_BOARD_04 = "168436"