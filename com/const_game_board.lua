require("mock/default")
require("com/enum_const")

--Boards ----------------------------------------------------------------------------------
NAME_BOARD_GAME = "game_board"

-- Buttons ----------------------------------------------------------------------------
GAME_BOARD_BUTTON_SCALE = {x=0.6,z=0.6,y=1}
GAME_BOARD_BUTTON_WIDTH = 400
GAME_BOARD_BUTTON_HEIGHT = 200
GAME_BOARD_BUTTON_FONT_SIZE = 80

PARAM_GAME_BOARD_BUTTON_FINISH = {
    click_function="onButtonClickSetGameModeFinished",
    function_owner = self,
    width = 400, height = 400,
    scale=GAME_BOARD_BUTTON_SCALE, font_size=120,
    position = Vector(0.80, 1.0, -0.65),
    label = "确认", tooltip = "点击以确认游玩模式设置",
}

PARAM_GAME_BOARD_BUTTON_SWITCH_GAME_GOAL = {
    click_function="onButtonClickSwitchGameGoal",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    scale=GAME_BOARD_BUTTON_SCALE, font_size=GAME_BOARD_BUTTON_FONT_SIZE,
    position = Vector(-0.65, 1.0, -0.78),
}

PARAM_GAME_BOARD_BUTTON_SWITCH_DECK_SET = {
    click_function="onButtonClickSwitchDeckSet",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    scale=GAME_BOARD_BUTTON_SCALE, font_size=GAME_BOARD_BUTTON_FONT_SIZE,
    position = Vector(0.05, 1.0, -0.78),
}

PARAM_GAME_BOARD_BUTTON_SWITCH_ROLE = {
    click_function="onButtonClickSwitchRole",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    scale=GAME_BOARD_BUTTON_SCALE, font_size=GAME_BOARD_BUTTON_FONT_SIZE,
    position = Vector(-0.65, 1.0, -0.53),
}

PARAM_GAME_BOARD_BUTTON_SWITCH_BP_STRATEGY = {
    click_function="onButtonClickSwitchBpStrategy",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    scale=GAME_BOARD_BUTTON_SCALE, font_size=GAME_BOARD_BUTTON_FONT_SIZE,
    position = Vector(0.05, 1.0, -0.53),
}

PARAM_SWITCH_BUTTON_CHANGE = {
    [1] = {
        [EnumGameGoal.QUICK] = {label = "传奇-快速", tooltip = "点击切换至传奇-标准", color = __BUTTON_COLOR_DEFAULT},
        [EnumGameGoal.STANDARD] = {label = "传奇-标准", tooltip = "点击切换至传奇-快速", color = __BUTTON_COLOR_YELLOW},
    },
    [2] = {
        [EnumDeckSet.STD] = {label = "牌堆-标准", tooltip = "点击切换至牌堆-Dlc01", color = __BUTTON_COLOR_DEFAULT},
        [EnumDeckSet.DLC01] = {label ="牌堆-Dlc01", tooltip = "点击切换至牌堆-标准", color = __BUTTON_COLOR_YELLOW},
    },
    [3] = {
        [false] = {label = "角色-禁用", tooltip = "点击启用角色", color = __BUTTON_COLOR_DEFAULT},
        [true] = {label = "角色-启用", tooltip = "点击禁用角色", color = __BUTTON_COLOR_GREEN},
    },
    [4] = {
        [EnumBPStrategy.FREE] = {label ="BP-自由", tooltip = "点击切换至标准BP", color = __BUTTON_COLOR_PURPLE},
        [EnumBPStrategy.STANDARD] = {label ="BP-标准", tooltip = "点击切换至自由BP", color = __BUTTON_COLOR_YELLOW},
    },
}

LIST_PARAM_GAME_BOARD_BUTTONS = {
    PARAM_GAME_BOARD_BUTTON_FINISH,
    PARAM_GAME_BOARD_BUTTON_SWITCH_GAME_GOAL,
    PARAM_GAME_BOARD_BUTTON_SWITCH_DECK_SET,
    PARAM_GAME_BOARD_BUTTON_SWITCH_ROLE,
    PARAM_GAME_BOARD_BUTTON_SWITCH_BP_STRATEGY
}

-- Decks --------------------------------------------------------------------------------
LIST_PARAM_LEGEND_DISPLAY = {
    [EnumGameGoal.QUICK] = {
        [1] = {idx = 2, idz = 1},
        [2] = {idx = 3, idz = 1},
        [3] = {idx = 1, idz = 1},
        [4] = {}, [5] = {}, [6] = {}, [7] = {},
    },
    [EnumGameGoal.STANDARD] = {
        [1] = {}, [2] = {},
        [3] = {idx = 1, idz = 1},
        [4] = {idx = 2, idz = 1},
        [5] = {idx = 3, idz = 1},
        [6] = {idx = 1, idz = 2},
        [7] = {idx = 2, idz = 2},
    }
}

GAME_BOARD_PATTERN = {
    origin = Vector(-5, 0.2, 0.2),
    dx =  4.90, dz = -5.50,
}

--Zones ------------------------------------------------------------------------------------
NAME_ZONE_LEGEND_DISPLAY = "zone_legend_display"
NAME_ZONE_ROLE_PICK = "zone_role_pick"

PARAM_SCRIPTING_TRIGGER_LEGEND = {
    type        = DEFAULT_SPAWN_TYPE_SCRIPTING_TRIGGER,
    rotation    = {0, 0, 0},
}
-- ref to game board (for legend display)
LIST_PARAM_SCRIPTING_LEGEND_DISPLAY = {
    [NAME_ZONE_LEGEND_DISPLAY] = {
        [KEYWORD_ZONE_DECK] = {
            position = {x=0, y=0.0, z=0},
            scale =  {x=17.50, y=1.00, z=16.60}
        }
    }
}

-- ref to game board (for player pick the role)
LIST_PARAM_SCRIPTING_ROLE_PICK = {
    [NAME_ZONE_ROLE_PICK] = {
        [KEYWORD_ZONE_DECK] = {
            position = {x=12.5, y=0.0, z=5.0,},
        }
    },
}

-- variant
GUID_GAME_BOARD = "ef690b"