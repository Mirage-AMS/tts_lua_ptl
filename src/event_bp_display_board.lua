require("mock/default")
require("com/const")
require("com/enum_const")
require("com/const_bp_display_board")
require("com/const_display_board")
require("com/basic")

local function getBpDisplayZone()
    local zone = GAME:getPublicService():getPublicZone(NAME_ZONE_BP_DISPLAY_BOARD)
    if not zone then
        error("fatal error: bp display zone is nil")
    end
    return zone
end

function setBpDisplayBoardVisibility(visible)
    local board = GAME:getPublicService():getPublicBoard(NAME_BOARD_BP_DISPLAY)
    if not board then
        error("fatal error: bp display board is nil")
    end
    board:setVisible(visible)
end

function clearBpDisplayZone()
    local zone = getBpDisplayZone()
    local deckSlot = zone and zone.deck_slot
    if not deckSlot then
        error("fatal error: bp display zone deck_slot is nil")
    end
    for _, card in ipairs(deckSlot:getCardObjects() or {}) do
        card.destruct()
    end
end

function dealBpDisplayCards()
    local zone = getBpDisplayZone()
    local deckSlot = zone and zone.deck_slot
    if not deckSlot then
        error("fatal error: bp display zone deck_slot is nil")
    end

    local layout = BP_DISPLAY_BOARD_LAYOUT
    if not layout then
        error("fatal error: BP_DISPLAY_BOARD_LAYOUT is nil")
    end

    local cols = layout.cols
    local rows = layout.rows
    local dealNum = cols * rows
    local faceupNum = layout.max_count

    --- build-up a random role pool
    local rolePool = {}
    for roleKey, _ in pairs(ROLE_REGISTER_DICT) do
        table.insert(rolePool, roleKey)
    end
    local randomRolePool = getRandomSubset(rolePool, dealNum)

    --- check if equal
    if #randomRolePool ~= dealNum then error("fatal error: role pool is not equal") end

    local publicService = GAME:getPublicService()
    local originPos = deckSlot:getPosition() or Vector(0,0,0)
    local originShift = layout.origin or Vector(0,0,0)
    local originPos = originPos + originShift
    local xShift = layout.x_shift
    local zShift = layout.z_shift
    local yOffset = 0.0

    for index, roleKey in ipairs(randomRolePool) do
        local roleData = ROLE_REGISTER_DICT[roleKey] or {}
        local roleItem = roleData[KWORD_ITEM] or {}
        local item = roleItem[1] or {}
        if item.origin ~= EnumItemOrigin.DEV_DECK then
            error("fatal error: character card "..roleKey.." is not from dev deck")
        end

        --- check if the card is face up or face down
        local isFlip = index <= faceupNum
        local rot = isFlip and __CARD_ROTATION_FACE_UP or __CARD_ROTATION_FACE_DOWN
        
        --- calculate position
        local col = ((index - 1) % cols)
        local row = math.floor((index - 1) / cols)
        local pos = originPos + Vector(col * xShift, yOffset, row * zShift)

        --- clone a card from dev deck
        local deck = publicService:getDevDeck(item.prefix)
        if not deck then error("fatal error: could not find dev deck "..item.prefix) end
        local clonedObject = deck.clone({position = pos, rotation = rot})
        local takeParam = {index = item.index - 1, position = pos, rotation = rot}
        clonedObject.takeObject(takeParam)
        local remnantObject = clonedObject.remainder and clonedObject.remainder or clonedObject
        remnantObject.destruct()
    end
end

function onButtonClickBpDisplayAction(_, _, alt_click)
    if alt_click then clearBpDisplayZone()
    else dealBpDisplayCards()
    end
end


function applyBPStrategy(strategy)
    local rolePickZone = GAME:getPublicService():getPublicZone(NAME_ZONE_ROLE_PICK)
    if not rolePickZone then
        error("fatal error: could not find role pick zone")
    end

    if strategy == EnumBPStrategy.RANDOM then
        -- shuffle role pick deck
        rolePickZone:shuffleDeck()

        -- deal role pick cards
        local dealNum = 5
        local playerService = GAME:getPlayerService()
        local playerList = playerService:getSeatedPlayerColorList()
        for _, player_color in ipairs(playerList) do
            rolePickZone:dealDeckCardIntoHand(dealNum, player_color)
        end

        Wait.time(
            function()
                rolePickZone:destructDeck()
            end,
            1
        )

    elseif strategy == EnumBPStrategy.STANDARD then
        setBpDisplayBoardVisibility(true)
        Wait.time(
            function()
                rolePickZone:destructDeck()
            end,
            1
        )

    elseif strategy == EnumBPStrategy.FREE then
        rolePickZone:shuffleDeck()
    end

end