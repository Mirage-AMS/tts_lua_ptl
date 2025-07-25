require("mock/default")
require("com/enum_const")
require("com/const_dev_board")
require("com/const_game_board")

KWORD_ORDER = "order"
KWORD_DIFFICULTY = "difficulty"
KWORD_PREFERENCE = "preference"
KWORD_NICKNAME = "nickname"
KWORD_ITEM = "item"

-- buttons
DISPLAY_BOARD_BUTTON_SCALE = {x=0.6,z=0.6,y=0.5}
DISPLAY_BOARD_BUTTON_WIDTH = 300
DISPLAY_BOARD_BUTTON_HEIGHT = 100
DISPLAY_BOARD_BUTTON_FONT_SIZE = 70

PARAM_DISPLAY_BOARD_BUTTON_REFRESH = {
    click_function="onChangeDisplayBoardPageRefresh",
    function_owner = self,
    width = 100, height = 100,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(1.25, 1.0, -1.0),
    label = "🔄", tooltip = "左键重置/右键刷新"
}

PARAM_DISPLAY_BOARD_BUTTON_SWITCH_PREV_PAGE = {
    click_function="onChangeDisplayBoardPagePrev",
    function_owner = self,
    width = 50, height = 100,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(-0.15, 1.0, 1.0),
    label = "<", tooltip = "上一页",
}

PARAM_DISPLAY_BOARD_BUTTON_SWITCH_NEXT_PAGE = {
    click_function="onChangeDisplayBoardPageNext",
    function_owner = self,
    width = 50, height = 100,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(0.15, 1.0, 1.0),
    label = ">", tooltip = "下一页",
}

PARAM_DISPLAY_BOARD_BUTTON_SWITCH_PREFERENCE = {
    click_function="onChangeDisplayBoardSettingPreference",
    function_owner = self,
    width = 350, height = 65,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(-1.10, 1.0, -1.0),
}

PARAM_DISPLAY_BOARD_BUTTON_SWITCH_SORT_BY = {
    click_function="onChangeDisplayBoardSettingSortBy",
    function_owner = self,
    width = 350, height = 65,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(0.82, 1.0, -1.0),
}

PARAM_DISPLAY_BOARD_BUTTON_SWITCH_IS_REVERSE = {
    click_function="onChangeDisplayBoardSettingIsReverse",
    function_owner = self,
    width = 100, height = 100,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(1.10, 1.0, -1.0),
}

LIST_PARAM_DISPLAY_BOARD_BUTTONS = {
    [1] = PARAM_DISPLAY_BOARD_BUTTON_REFRESH,
    [2] = PARAM_DISPLAY_BOARD_BUTTON_SWITCH_PREV_PAGE,
    [3] = PARAM_DISPLAY_BOARD_BUTTON_SWITCH_NEXT_PAGE,
    [4] = PARAM_DISPLAY_BOARD_BUTTON_SWITCH_PREFERENCE,
    [5] = PARAM_DISPLAY_BOARD_BUTTON_SWITCH_SORT_BY,
    [6] = PARAM_DISPLAY_BOARD_BUTTON_SWITCH_IS_REVERSE,
}

PARAM_DISPLAY_BOARD_SWITCH_BUTTON_CHANGE = {
    [1] = {
        [false] = {color = __BUTTON_COLOR_DEFAULT},
        [true] = {color = __BUTTON_COLOR_DISABLE},
    },
    [2] = {
        [false] = {color = __BUTTON_COLOR_DEFAULT},
        [true] = {color = __BUTTON_COLOR_DISABLE},
    },
    [3]= {
        [EnumRolePreference.NONE] = {label = "全部显示", tooltip = "点击切换至采集角色", color = __BUTTON_COLOR_DEFAULT},
        [EnumRolePreference.GATHERING] = {label = "采集角色", tooltip = "点击切换至狩猎角色", color = __BUTTON_COLOR_GREEN},
        [EnumRolePreference.HUNTING] = {label = "狩猎角色", tooltip = "点击切换至泛用角色", color = __BUTTON_COLOR_RED},
        [EnumRolePreference.NO_PREFERENCE] = {label = "泛用角色", tooltip = "点击切换至全部显示", color = __BUTTON_COLOR_YELLOW},
    },
    [4] = {
        [EnumDisplayBoardSort.DIFFICULTY] = {label = "难度顺序", tooltip = "点击切换至时间顺序", color = __BUTTON_COLOR_DEFAULT},
        [EnumDisplayBoardSort.TIME] = {label ="时间顺序", tooltip = "点击切换至难度顺序", color = __BUTTON_COLOR_PURPLE},
    },
    [5] = {
        [false] = {label = "↑", tooltip = "点击切换至倒序"},
        [true]  = {label = "↓", tooltip = "点击切换至顺序"},
    },
}

--- input
PARAM_DISPLAY_BOARD_INPUT_PAGE_NUM = {
    input_function="onChangeDisplayBoardPageNum",
    function_owner = self,
    width = 150, height = 100,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(0.00, 1.0, 1.0),
    alignment = 3,
    validation = 2, -- Integer validation
}
PARAM_DISPLAY_BOARD_INPUT_SEARCH_TEXT = {
    input_function="onChangeDisplayBoardSettingSearchText",
    function_owner = self,
    width = 1200, height = 110,
    scale=DISPLAY_BOARD_BUTTON_SCALE, font_size=75,
    position = Vector(-0.15, 1.0, -1.0),
    alignment = 5,
}

LIST_PARAM_DISPLAY_BOARD_INPUTS = {
    PARAM_DISPLAY_BOARD_INPUT_PAGE_NUM,
    PARAM_DISPLAY_BOARD_INPUT_SEARCH_TEXT,
}

-- zones
NAME_ZONE_DISPLAY_BOARD = "zone_display_board"
PARAM_SCRIPTING_TRIGGER_DISPLAY_BOARD = {
    type        = DEFAULT_SPAWN_TYPE_SCRIPTING_TRIGGER,
    rotation    = {0, 0, 0},
}
LIST_PARAM_SCRIPTING_DISPLAY_BOARD = {
    [NAME_ZONE_DISPLAY_BOARD] = {
        [KEYWORD_ZONE_DECK] = {
            position = {x=0, y=0.0, z=0},
            scale =  {x=30, y=1.00, z=20}
        }
    }
}

-- layout
ROLE_DISPLAY_BOARD_PATTERN = {
    origin = Vector(-11.84, 0.20, 7.38),
    dx =  15.11, dz = -7.38,
    dxx = 4.3, dzz = 0.0,
    dxxx = 1.0, dzzz = 0.0,
}

-- var
NAME_BOARD_DISPLAY = "board_display"
GUID_DISPLAY_BOARD = "b97de7"

-- all roles here
KWORD_ROLE_DAVIAN = "role_davian" ---- 达维安，巨人杀手
KWORD_ROLE_GELMAN = "role_gelman" ---- 盖尔曼，历战勇士
KWORD_ROLE_Ell = "role_ell" ---- 埃尔，铁与火
KWORD_ROLE_ZERIEL = "role_zeriel" ---- 泽丽尔，树屋精灵
KWORD_ROLE_PAUL_PAULA = "role_paul_paula" ---- 保罗与波娜，那对兄妹
KWORD_ROLE_KATHERINE = "role_katherine" ---- 凯瑟琳，完美主义
KWORD_ROLE_SIMA = "role_sima" ---- 希玛，狩魔不息
KWORD_ROLE_TALVAN = "role_talvan" ---- 塔尔凡，漫游吟者
KWORD_ROLE_NOVI = "role_novi" ---- 诺维，初生牛犊
KWORD_ROLE_SHYLOCK = "role_shylock" ---- 夏洛克，独断专营
KWORD_ROLE_SOLAN = "role_solan" ---- 索兰，高山行者
KWORD_ROLE_PHYLLIS = "role_phyllis" ---- 菲莉斯，圣女垂怜
KWORD_ROLE_SOURCER = "role_sourcer" ---- 法师，王朝余烬
KWORD_ROLE_LEON = "role_leon" ---- 莱奥，命运之剑
KWORD_ROLE_ALFRED = "role_alfred" ---- 艾尔弗里德，大展宏图
KWORD_ROLE_LEILANA = "role_leilana" ---- 莱拉娜，丰饶祭祀
KWORD_ROLE_EUGENIE = "role_eugenie" ---- 欧也妮，匠心独运
KWORD_ROLE_FLINT = "role_flint" ---- 弗林特，栖身林原
KWORD_ROLE_ARYA = "role_arya" ---- 艾丽娅，驯鹰人
KWORD_ROLE_CARLOS = "role_carlos" ---- 卡洛斯，万咒环身
KWORD_ROLE_KAY = "role_kay" ---- 凯，嗜赌成性
KWORD_ROLE_NEXT = "role_next" ---- 下一角色，用于测试

NAME_CONTAINER_ROLE_PHYLLIS_HOLY_WATER = "container_role_phyllis_holy_water"
GUID_CONTAINER_ROLE_PHYLLIS_HOLY_WATER = ""
NAME_CONTAINER_ROLE_ARYA_EAGLET = "container_role_arya_eaglet"
GUID_CONTAINER_ROLE_ARYA_EAGLET = ""

ROLE_REGISTER_DICT = {
    [KWORD_ROLE_DAVIAN] = {
        [KWORD_ORDER]       = 1,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.HUNTING,
        [KWORD_NICKNAME]    = {"达维安", "巨杀"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 1, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 1, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 2, loc_idx = 3},
        }
    },
    [KWORD_ROLE_GELMAN] = {
        [KWORD_ORDER]       = 2,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.EASY,
        [KWORD_PREFERENCE]  = EnumRolePreference.HUNTING,
        [KWORD_NICKNAME]    = {"盖尔曼"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 2, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 3, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 4, loc_idx = 3},
        }
    },
    [KWORD_ROLE_Ell] = {
        [KWORD_ORDER]       = 3,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.EASY,
        [KWORD_PREFERENCE]  = EnumRolePreference.GATHERING,
        [KWORD_NICKNAME]    = {"埃尔", "铁与火", "火老头"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 3, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 5, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 6, loc_idx = 3},
        }
    },
    [KWORD_ROLE_ZERIEL] = {
        [KWORD_ORDER]       = 4,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.EASY,
        [KWORD_PREFERENCE]  = EnumRolePreference.GATHERING,
        [KWORD_NICKNAME]    = {"泽丽尔", "树屋", "精灵"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 4, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 7, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 8, loc_idx = 3},
        }
    },
    [KWORD_ROLE_PAUL_PAULA] = {
        [KWORD_ORDER]       = 5,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"保罗", "波娜", "双子"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 5, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 9, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 10, loc_idx = 3},
        }
    },
    [KWORD_ROLE_KATHERINE] = {
        [KWORD_ORDER]       = 6,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"凯瑟琳", "完美"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 6, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 11, loc_idx = 3},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 12, loc_idx = 2},
        }
    },
    [KWORD_ROLE_SIMA] = {
        [KWORD_ORDER]       = 7,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.HUNTING,
        [KWORD_NICKNAME]    = {"希玛", "牢玛", "牢马", "老马"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 7, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 13, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 14, loc_idx = 3},
        }
    },
    [KWORD_ROLE_TALVAN] = {
        [KWORD_ORDER]       = 8,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.HARD,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"塔尔凡", "风老头"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 8, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 15, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 16, loc_idx = 3},
        }
    },
    [KWORD_ROLE_NOVI] = {
        [KWORD_ORDER]       = 9,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"诺维", "野蛮人"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 9, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 17, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 18, loc_idx = 3},
        }
    },
    [KWORD_ROLE_SHYLOCK] = {
        [KWORD_ORDER]       = 10,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"夏洛克", "商人"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 10, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 19, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 20, loc_idx = 3},
        }
    },
    [KWORD_ROLE_SOLAN] = {
        [KWORD_ORDER]       = 11,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.GATHERING,
        [KWORD_NICKNAME]    = {"索兰", "高山", "爆破"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 11, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 21, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 22, loc_idx = 3},
        }
    },
    [KWORD_ROLE_PHYLLIS] = {
        [KWORD_ORDER]       = 12,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.HARD,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"菲莉斯", "圣女"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT01, index = 12, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 23, loc_idx = 2, loc_idxx = 1},
            [3] = {origin = EnumItemOrigin.DEV_CONTAINER_ITEM, prefix = NAME_CONTAINER_ROLE_PHYLLIS_HOLY_WATER, loc_idx = 2, loc_idxx = 2},
            [4] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF01, index = 24, loc_idx = 3},
        }
    },
    [KWORD_ROLE_SOURCER] = {
        [KWORD_ORDER]       = 13,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.EASY,
        [KWORD_PREFERENCE]  = EnumRolePreference.HUNTING,
        [KWORD_NICKNAME]    = {"法师", "光头", "伏地魔"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 1, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 1, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 2, loc_idx = 3},
        }
    },
    [KWORD_ROLE_LEON] = {
        [KWORD_ORDER]       = 14,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"莱奥", "牢剑", "牢奥"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 2, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 3, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 4, loc_idx = 3, loc_idxx = 1},
            [4] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 5, loc_idx = 3, loc_idxx = 2},
            [5] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 6, loc_idx = 3, loc_idxx = 3},
        }
    },
    [KWORD_ROLE_ALFRED] = {
        [KWORD_ORDER]       = 15,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.HARD,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"阿尔弗雷德", "执政官", "牢执", "白板"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 3, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 7, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 8, loc_idx = 3},
        }
    },
    [KWORD_ROLE_LEILANA] = {
        [KWORD_ORDER]       = 16,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.GATHERING,
        [KWORD_NICKNAME]    = {"莱拉娜"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 4, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 9, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 10, loc_idx = 3},
        }
    },
    [KWORD_ROLE_EUGENIE] = {
        [KWORD_ORDER]       = 17,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"欧也妮", "工匠"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 5, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 11, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 12, loc_idx = 3},
        }
    },
    [KWORD_ROLE_FLINT] = {
        [KWORD_ORDER]       = 18,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.EASY,
        [KWORD_PREFERENCE]  = EnumRolePreference.GATHERING,
        [KWORD_NICKNAME]    = {"弗林特", "砍树", "烂草"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 6, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 13, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 14, loc_idx = 3},
        }
    },
    [KWORD_ROLE_ARYA] = {
        [KWORD_ORDER]       = 19,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.HUNTING,
        [KWORD_NICKNAME]    = {"艾丽娅", "驯鹰", "双鹰", "牢艾", "牢鹰"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 7, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 15, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_CONTAINER_ITEM, prefix = GUID_CONTAINER_ROLE_ARYA_EAGLET, loc_idx = 3, loc_idxx = 1, flip = true},
            [4] = {origin = EnumItemOrigin.DEV_CONTAINER_ITEM, prefix = GUID_CONTAINER_ROLE_ARYA_EAGLET, loc_idx = 3, loc_idxx = 2, flip = false},
        }
    },
    [KWORD_ROLE_CARLOS] = {
        [KWORD_ORDER]       = 20,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"卡洛斯", "万法", "法师"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 8, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 16, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 17, loc_idx = 3},
        }
    },
    [KWORD_ROLE_KAY] = {
        [KWORD_ORDER]       = 21,
        [KWORD_DIFFICULTY]  = EnumRoleDifficulty.NORMAL,
        [KWORD_PREFERENCE]  = EnumRolePreference.NO_PREFERENCE,
        [KWORD_NICKNAME]    = {"凯", "老千", "赌徒", "赌狗"},
        [KWORD_ITEM]        = {
            [1] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INT02, index = 9, loc_idx = 1},
            [2] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 18, loc_idx = 2},
            [3] = {origin = EnumItemOrigin.DEV_DECK, prefix = PREFIX_RO_INF02, index = 19, loc_idx = 3},
        }
    },
}