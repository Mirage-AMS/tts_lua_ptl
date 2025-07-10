require("mock/default")
require("com/enum_const")

GAME_BOARD_BUTTON_SCALE = {x=0.4,z=0.4,y=1}
GAME_BOARD_BUTTON_WIDTH = 400
GAME_BOARD_BUTTON_HEIGHT = 200
GAME_BOARD_BUTTON_FONT_SIZE_BIG = 120
GAME_BOARD_BUTTON_FONT_SIZE = 80

PARAM_GAME_BOARD_BUTTON_FINISH = {
    click_function="onButtonClickSetGameModeFinished",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    position = Vector(0.9, 1.0, 0.9),
    label = "完成", tooltip = "点击以完成模式设置",
}

PARAM_GAME_BOARD_BUTTON_SWITCH_GAME_GOAL = {
    click_function="onButtonClickSwitchGameGoal",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    position = Vector(-0.7, 1.0, 0.9),
}

PARAM_GAME_BOARD_BUTTON_SWITCH_DECK_SET = {
    click_function="onButtonClickSwitchDeckSet",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    position = Vector(-0.3, 1.0, 0.9),
}

PARAM_GAME_BOARD_BUTTON_SWITCH_ROLE = {
    click_function="onButtonClickSwitchRole",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    position = Vector(0.1, 1.0, 0.9),
}

PARAM_GAME_BOARD_BUTTON_SWITCH_BP_STRATEGY = {
    click_function="onButtonClickSwitchBpStrategy",
    function_owner = self,
    width = GAME_BOARD_BUTTON_WIDTH, height = GAME_BOARD_BUTTON_HEIGHT,
    position = Vector(0.5, 1.0, 0.9),
}

PARAM_SWITCH_BUTTON_CHANGE = {
    [1] = {
        [EnumGameGoal.QUICK] = {label = "传奇-快速", tooltip = "点击切换至传奇-标准"},
        [EnumGameGoal.STANDARD] = {label = "传奇-标准", tooltip = "点击切换至传奇-快速"},
    },
    [2] = {
        [EnumDeckSet.STD] = {label = "牌堆-标准", tooltip = "点击切换至牌堆-标准"},
        [EnumDeckSet.DLC01] = {label ="牌堆-Dlc01", tooltip = "点击切换至牌堆-Dlc01"},
    },
    [3] = {
        [false] = {label = "角色-禁用", tooltip = "点击启用角色"},
        [true] = {label = "角色-启用", tooltip = "点击禁用角色"},
    },
    [4] = {
        [EnumBPStrategy.STANDARD] = {label ="BP-标准", tooltip = "点击切换至自由BP"},
        [EnumBPStrategy.RANDOM] = {label ="BP-自由", tooltip = "点击切换至标准BP"}
    },
}

LIST_PARAM_GAME_BOARD_BUTTONS = {
    PARAM_GAME_BOARD_BUTTON_FINISH,
    PARAM_GAME_BOARD_BUTTON_SWITCH_GAME_GOAL,
    PARAM_GAME_BOARD_BUTTON_SWITCH_DECK_SET,
    PARAM_GAME_BOARD_BUTTON_SWITCH_ROLE,
    PARAM_GAME_BOARD_BUTTON_SWITCH_BP_STRATEGY
}


LIST_PARAM_LEGEND_DISPLAY = {
    [EnumGameGoal.QUICK] = {
        [1] = {idx = 2, idz = 1},
        [2] = {idx = 3, idz = 1},
        [3] = {idx = 1, idz = 1},
        [4] = nil, [5] = nil, [6] = nil, [7] = nil,
    },
    [EnumGameGoal.STANDARD] = {
        [1] = nil, [2] = nil,
        [3] = {idx = 1, idz = 1},
        [4] = {idx = 2, idz = 1},
        [5] = {idx = 3, idz = 1},
        [6] = {idx = 1, idz = 2},
        [7] = {idx = 2, idz = 2},
    }
}

GAME_BOARD_PATTERN = {
    origin = Vector(0, 0.2, 0),
    dx =  4.90, dz = -5.50,
}
