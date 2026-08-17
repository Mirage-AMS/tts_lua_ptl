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
    position = Vector(-1.07, 1.0, -1.05),
    label = "发牌/清空", tooltip = "左键发牌，右键清空",
}

LIST_PARAM_BP_DISPLAY_BOARD_BUTTONS = {
    PARAM_BP_DISPLAY_BOARD_BUTTON_ACTION,
}

-- Zones -----------------------------------------------------------------------------------
NAME_ZONE_BP_DISPLAY_BOARD = "zone_bp_display"
PARAM_SCRIPTING_TRIGGER_BP_DISPLAY_BOARD = {
    type        = DEFAULT_SPAWN_TYPE_SCRIPTING_TRIGGER,
    rotation    = {0, 0, 0},
}

LIST_PARAM_SCRIPTING_BP_DISPLAY = {
    [NAME_ZONE_BP_DISPLAY_BOARD] = {
        [KEYWORD_ZONE_DECK] = {
            position = {x=0.0, y=0.0, z=0.0},
            scale =  {x=30, y=1.00, z=22}
        }
    }
}

BP_DISPLAY_BOARD_LAYOUT = {
    origin = Vector(-11.60, 0.5, 8.4),
    cols = 6, rows = 4,
    x_shift = 4.63, z_shift = -5.6,
    max_count = 12,
}

-- Variant ---------------------------------------------------------------------------------
GUID_BP_DISPLAY_BOARD = "6c43d5"
