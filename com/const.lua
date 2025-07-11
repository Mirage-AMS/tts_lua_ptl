require("mock/default")

-- TYPE
DEFAULT_TYPE_CARD = "Card"
DEFAULT_TYPE_DECK = "Deck"
DEFAULT_TYPE_TILE = "Tile"
DEFAULT_TYPE_SCRIPTING = "Scripting"
DEFAULT_TYPE_BAG = "Bag"
DEFAULT_TAG_TOKEN = "Token"
DEFAULT_SPAWN_TYPE_SCRIPTING_TRIGGER = "ScriptingTrigger"

-- COLOR
DEFAULT_COLOR_RED = "Red"
DEFAULT_COLOR_BLUE = "Blue"
DEFAULT_COLOR_YELLOW = "Yellow"
DEFAULT_COLOR_PURPLE = "Purple"
DEFAULT_COLOR_WHITE = "White"
DEFAULT_COLOR_GREY = "Grey"
DEFAULT_COLOR_BLACK = "Black"
DEFAULT_PLAYER_COLOR_LIST = {DEFAULT_COLOR_RED, DEFAULT_COLOR_PURPLE, DEFAULT_COLOR_BLUE, DEFAULT_COLOR_YELLOW}
DEFAULT_NON_PLAYER_COLOR_LIST = {DEFAULT_COLOR_WHITE, DEFAULT_COLOR_GREY, DEFAULT_COLOR_BLACK}


-- ZONE
KEYWORD_ZONE_DECK = "deck_slot"
KEYWORD_ZONE_DISCARD = "discard_slot"
KEYWORD_ZONE_DISPLAY = "display_slots"
KEYWORD_ZONE_TOP = "top_slots"
KEYWORD_ZONE_DISPLAY_PATTERN = "display_pattern"
KEYWORD_ZONE_TOP_PATTERN = "top_pattern"

-- --PUBLIC
NAME_ZONE_MOUNTAIN = "deck_mountain"
NAME_ZONE_FOREST = "deck_forest"
NAME_ZONE_DUNGEON = "deck_dungeon"
NAME_ZONE_MARKET = "deck_market"
NAME_ZONE_CONVENTICLE = "deck_conventicle"
PUBLIC_ZONE_NAME_LIST = {
    [1] = NAME_ZONE_MOUNTAIN,
    [2] = NAME_ZONE_FOREST,
    [3] = NAME_ZONE_DUNGEON,
    [4] = NAME_ZONE_MARKET,
    [5] = NAME_ZONE_CONVENTICLE,
}
PARAM_MAIN_BOARD_HEIGHT = 2.0
PARAM_SCRIPTING_TRIGGER_DEFAULT = {
    type        = DEFAULT_SPAWN_TYPE_SCRIPTING_TRIGGER,
    scale       = {x=3.75, z=5.25, y=5},
    rotation    = {0, 0, 0},
}

LIST_PARAM_SCRIPING_TRIGGER = {
    [NAME_ZONE_MOUNTAIN] = {
        [KEYWORD_ZONE_DECK] = {
            position    = {x=-7.6, z=15.2, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISCARD] = {
            position    = {x=2.2, z=15.2, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY] =     {
            position    = {x=-17.40, z=9.26,   y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY_PATTERN] = {
            x_num=5, x_shift=4.9,
            z_num=1, z_shift=0,
        },
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    },
    [NAME_ZONE_FOREST] = {
        [KEYWORD_ZONE_DECK] = {
            position    = {x=-7.6, z=3.0, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISCARD] = {
            position    = {x=2.2, z=3.0, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY] = {
            position    = {x=-17.40, z=-2.94,  y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY_PATTERN] = {
            x_num=5, x_shift=4.9,
            z_num=1, z_shift=0,
        },
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    },
    [NAME_ZONE_DUNGEON] = {
        [KEYWORD_ZONE_DECK] = {
            position    = {x=-7.6, z=-9.2, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISCARD] = {
            position    = {x=2.2, z=-9.2, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY] = {
            position    = {x=-17.40, z=-15.14, y=PARAM_MAIN_BOARD_HEIGHT },
        },
        [KEYWORD_ZONE_DISPLAY_PATTERN] = {
            x_num=5, x_shift=4.9,
            z_num=1, z_shift=0,
        },
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    },
    [NAME_ZONE_MARKET] = {
        [KEYWORD_ZONE_DECK] = {
            position    = {x=7.7, z=11.9, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISCARD] = {
            position    = {x=17.5, z=11.9, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY] = {
            position    = {x=7.7, z=6.06, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY_PATTERN] = {
            x_num=3, x_shift=4.9,
            z_num=2, z_shift=-5.60,
        },
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    },
    [NAME_ZONE_CONVENTICLE] = {
        [KEYWORD_ZONE_DECK] = {
            position    = {x=7.7, z=-12.2, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISCARD] =     {
            position    = {x=17.5, z=-12.2, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_DISPLAY] = nil,
        [KEYWORD_ZONE_DISPLAY_PATTERN] = nil,
        [KEYWORD_ZONE_TOP] = {
            position    = {x=7.7, z=-6.0, y=PARAM_MAIN_BOARD_HEIGHT},
        },
        [KEYWORD_ZONE_TOP_PATTERN] = {
            x_num=3, x_shift=4.9,
            z_num=1, z_shift=0,
        },
    },
}
-- --PRIVATE
NAME_ZONE_ELEMENT = "zone_element"
NAME_ZONE_BACKPACK = "zone_backpack"
NAME_ZONE_ABILITY = "zone_ability"
NAME_ZONE_DISCARD = "zone_discard"

PARAM_ROLE_BOARD_HEIGHT = 2.0
PARAM_SCRIPTING_TRIGGER_PLAYER_DEFAULT = {
    type        = DEFAULT_SPAWN_TYPE_SCRIPTING_TRIGGER,
    rotation    = {0, 0, 0},
}
PLAYER_ZONE_NAME_LIST = {
    [1] = NAME_ZONE_ELEMENT,
    [2] = NAME_ZONE_BACKPACK,
    [3] = NAME_ZONE_ABILITY,
    [4] = NAME_ZONE_DISCARD,
}
LIST_PARAM_SCRIPING_TRIGGER_PLAYER = {
    [NAME_ZONE_ELEMENT] = {
        [KEYWORD_ZONE_DECK] = {
            position =  {x=9.45, y=PARAM_ROLE_BOARD_HEIGHT, z=-5.30},
            scale =  {x=5.75, y=5.00, z=5.75}
        },
        [KEYWORD_ZONE_DISCARD] = nil,
        [KEYWORD_ZONE_DISPLAY] = nil,
        [KEYWORD_ZONE_DISPLAY_PATTERN] = nil,
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    },
    [NAME_ZONE_BACKPACK] = {
        [KEYWORD_ZONE_DECK] = {
            position =  {x=11.90, y=PARAM_ROLE_BOARD_HEIGHT, z=3.35},
            scale =  {x=10.50, y=5.00, z=9.80}
        },
        [KEYWORD_ZONE_DISCARD] = nil,
        [KEYWORD_ZONE_DISPLAY] = nil,
        [KEYWORD_ZONE_DISPLAY_PATTERN] = nil,
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    },
    [NAME_ZONE_ABILITY] = {
        [KEYWORD_ZONE_DECK] = {
            position =  {x=-4.25, y=PARAM_ROLE_BOARD_HEIGHT, z=0.00},
            scale =  {x=17.50, y=5.00, z=16.60}
        },
        [KEYWORD_ZONE_DISCARD] = nil,
        [KEYWORD_ZONE_DISPLAY] = nil,
        [KEYWORD_ZONE_DISPLAY_PATTERN] = nil,
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    },
    [NAME_ZONE_DISCARD] = {
        [KEYWORD_ZONE_DECK] = nil,
        [KEYWORD_ZONE_DISCARD] = {
            position =  {x=24, y=PARAM_ROLE_BOARD_HEIGHT, z=3.35},
            scale =  {x=10.50, y=5.00, z=9.80}
        },
        [KEYWORD_ZONE_DISPLAY] = nil,
        [KEYWORD_ZONE_DISPLAY_PATTERN] = nil,
        [KEYWORD_ZONE_TOP] = nil,
        [KEYWORD_ZONE_TOP_PATTERN] = nil,
    }
}
-- board
NAME_BOARD_MAIN = "main_board"
NAME_RUBBISH_BIN = "rubbish_bin"
NAME_BOARD_ROLE = "role_board"

-- variant
SCRIPT_VERSION = 2025071001

GUID_MAIN_BOARD = "5d757b"
GUID_RUBBISH_BIN = "70b9f6"
GUID_ROLE_BOARD_LIST = {
    [DEFAULT_COLOR_RED] = "ae4666",
    [DEFAULT_COLOR_PURPLE] = "7bcdb6",
    [DEFAULT_COLOR_BLUE] = "b4399c",
    [DEFAULT_COLOR_YELLOW] = "17ab85"
}

GAME = {}
