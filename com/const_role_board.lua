require("mock/default")
require("com/const")

-- buttons
ROLE_BOARD_BUTTON_SCALE = {x=0.4,z=0.4,y=1}
ROLE_BOARD_BUTTON_WIDTH = 400
ROLE_BOARD_BUTTON_HEIGHT = 200
ROLE_BOARD_BUTTON_FONT_SIZE = 80

PARAM_ROLE_BOARD_BUTTON_CLAIM_WINNER = {
    click_function="onPlayerClaimWinner",
    function_owner = self,
    width = ROLE_BOARD_BUTTON_WIDTH, height = ROLE_BOARD_BUTTON_HEIGHT,
    scale=ROLE_BOARD_BUTTON_SCALE, font_size=ROLE_BOARD_BUTTON_FONT_SIZE,
    position = Vector(0.82, 1.0, -1.0),
    label="宣言获胜", tooltip="玩家发起获胜投票"
}

---@type table[]
LIST_PARAM_ROLE_BOARD_BUTTONS = {
    PARAM_ROLE_BOARD_BUTTON_CLAIM_WINNER,
}