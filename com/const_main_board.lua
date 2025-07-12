require("mock/default")

-- BUTTON
NAME_BUTTON_INIT_GAME = "button_init"
NAME_BUTTON_CLAIM_FIRST = "button_claim_first"
NAME_BUTTON_BEGINNING_PHASE = "button_beginning_phase"
NAME_BUTTON_DRAW_PHASE = "button_draw_phase"
NAME_BUTTON_STANDBY_PHASE = "button_standby_phase"
NAME_BUTTON_ACTION_PHASE = "button_action_phase"
NAME_BUTTON_END_PHASE = "button_end_phase"
NAME_BUTTON_SHOW_THREE_CARD = "button_show_three_card"
DEFAULT_BUTTON_LIST = {
    [1] = NAME_BUTTON_INIT_GAME,
    [2] = NAME_BUTTON_CLAIM_FIRST,
    [3] = NAME_BUTTON_BEGINNING_PHASE,
    [4] = NAME_BUTTON_DRAW_PHASE,
    [5] = NAME_BUTTON_STANDBY_PHASE,
    [6] = NAME_BUTTON_ACTION_PHASE,
    [7] = NAME_BUTTON_END_PHASE,
}

DEFAULT_BUTTON_LOCATION_X = 1.3
DEFAULT_BUTTON_LOCATION_Y = 1.0
DEFAULT_BUTTON_WIDTH = 400
DEFAULT_BUTTON_HEIGHT = 200
DEFAULT_BUTTON_FONT_SIZE_BIG = 120
DEFAULT_BUTTON_FONT_SIZE = 80
DEFAULT_BUTTON_SCALE = {x=0.4,z=0.4,y=1}
DEFAULT_ROTATION = {0, 0, 0}

LIST_PARAM_ONLOAD_BUTTONS = {
    {
        click_function="onButtonClickInitGame",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=-0.90, x=DEFAULT_BUTTON_LOCATION_X, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="开局", tooltip="确保所有玩家就绪后点击开局"
    },
    {
        click_function="onButtonClickClaimFirst",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=-0.70, x=DEFAULT_BUTTON_LOCATION_X, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="认先", tooltip="完成重调手牌后, 首回合玩家点击认先"
    },
    {
        click_function="onButtonClickBeginningPhase",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=-0.50, x=DEFAULT_BUTTON_LOCATION_X, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="开始阶段", tooltip="回合玩家进入开始阶段"
    },
    {
        click_function="onButtonClickDrawPhase",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=-0.30, x=DEFAULT_BUTTON_LOCATION_X, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="抽牌阶段", tooltip="回合玩家进入抽牌阶段(左击抽牌/右击跳过抽牌)"
    },
    {
        click_function="onButtonClickStandbyPhase",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=-0.10, x=DEFAULT_BUTTON_LOCATION_X, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="准备阶段", tooltip="回合玩家进入准备阶段"
    },
    {
        click_function="onButtonClickActionPhase",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=0.10, x=DEFAULT_BUTTON_LOCATION_X, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="行动阶段", tooltip="回合玩家进入行动阶段"
    },
    {
        click_function="onButtonClickEndPhase",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=0.30, x=DEFAULT_BUTTON_LOCATION_X, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="结束阶段", tooltip="回合玩家进入结束阶段"
    },
    {
        click_function="onButtonClickShowThreeCard",
        function_owner = self,
        width=DEFAULT_BUTTON_WIDTH, height=DEFAULT_BUTTON_HEIGHT,
        position={z=0.92, x=0.7, y=DEFAULT_BUTTON_LOCATION_Y}, rotation=DEFAULT_ROTATION, scale=DEFAULT_BUTTON_SCALE, font_size=DEFAULT_BUTTON_FONT_SIZE,
        label="翻3张牌", tooltip="从牌堆顶翻3张牌(左击翻牌/右击返回洗切)"
    },
}