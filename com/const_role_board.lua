require("mock/default")
require("com/const")

-- buttons
ROLE_BOARD_BUTTON_SCALE = {x=0.8,z=0.8,y=1}
ROLE_BOARD_BUTTON_WIDTH = 400
ROLE_BOARD_BUTTON_HEIGHT = 200
ROLE_BOARD_BUTTON_FONT_SIZE = 120

PARAM_ROLE_BOARD_BUTTON_CLAIM_WINNER = {
    click_function="onPlayerClaimWinner",
    function_owner = self,
    width = ROLE_BOARD_BUTTON_WIDTH, height = ROLE_BOARD_BUTTON_HEIGHT,
    scale=ROLE_BOARD_BUTTON_SCALE, font_size=ROLE_BOARD_BUTTON_FONT_SIZE,
    position = Vector(-1.73, 1.0, 2.0),
    color = DEFAULT_COLOR_WHITE,
    label="宣胜", tooltip="玩家发起获胜投票"
}

---@type table[]
LIST_PARAM_ROLE_BOARD_BUTTONS = {
    PARAM_ROLE_BOARD_BUTTON_CLAIM_WINNER,
}