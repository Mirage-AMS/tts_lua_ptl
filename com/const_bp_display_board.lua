require("mock/default")
require("com/const")
require("com/enum_const")
require("com/const_game_board")

-- Boards ----------------------------------------------------------------------------------
NAME_BOARD_BP_DISPLAY = "bp_display_board"

-- Buttons ------------------------------------------------------------------------------
BP_DISPLAY_BOARD_BUTTON_SCALE = {x=0.6,z=0.6,y=0.8}
BP_DISPLAY_BOARD_BUTTON_WIDTH = 350
BP_DISPLAY_BOARD_BUTTON_HEIGHT = 100
BP_DISPLAY_BOARD_BUTTON_FONT_SIZE = 70

PARAM_BP_DISPLAY_BOARD_BUTTON_ACTION = {
    click_function="onButtonClickBpDisplayAction",
    function_owner = self,
    width = BP_DISPLAY_BOARD_BUTTON_WIDTH, height = BP_DISPLAY_BOARD_BUTTON_HEIGHT,
    scale=BP_DISPLAY_BOARD_BUTTON_SCALE, font_size=BP_DISPLAY_BOARD_BUTTON_FONT_SIZE,
    position = Vector(0.0, 1.0, 0.0),
    label = "发牌/清空", tooltip = "左键发牌，右键清空",
}

LIST_PARAM_BP_DISPLAY_BOARD_BUTTONS = {
    PARAM_BP_DISPLAY_BOARD_BUTTON_ACTION,
}

-- Zones -----------------------------------------------------------------------------------
NAME_ZONE_BP_DISPLAY = "zone_bp_display"

PARAM_SCRIPTING_TRIGGER_BP_DISPLAY = {
    type        = DEFAULT_SPAWN_TYPE_SCRIPTING_TRIGGER,
    rotation    = {0, 0, 0},
}
LIST_PARAM_SCRIPTING_BP_DISPLAY = {
    [NAME_ZONE_BP_DISPLAY] = {
        [KEYWORD_ZONE_DISPLAY] = {
            position = {x=0, y=0.0, z=0},
            scale = {x=30, y=1.00, z=20}
        },
        [KEYWORD_ZONE_DISPLAY_PATTERN] = {
            x_num=5, x_shift=4.9,
            z_num=4, z_shift=-5.3,
        },
    }
}

-- Variant ---------------------------------------------------------------------------------
GUID_BP_DISPLAY_BOARD = "to_be_replaced"
