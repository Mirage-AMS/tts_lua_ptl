require("mock/default")
require("com/const")
require("com/enum_const")
require("com/const_bp_display_board")
require("com/const_display_board")

local function getBpDisplayZone()
    local zone = GAME:getPublicService():getPublicZone(NAME_ZONE_BP_DISPLAY)
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
    for _, slot in ipairs(zone and zone.display_slots or {}) do
        for _, card in ipairs(slot:getCardObjects() or {}) do
            card.destruct()
        end
    end
end

function dealBpDisplayCards()
    local zone = getBpDisplayZone()
    clearBpDisplayZone()

    local slotList = zone.display_slots or {}
    if #slotList == 0 then return end

    local itemPool = {}
    for _, roleData in pairs(ROLE_REGISTER_DICT) do
        local roleItems = roleData[KWORD_ITEM]
        if roleItems and #roleItems > 0 then
            for _, item in ipairs(roleItems) do
                table.insert(itemPool, deepCopy(item))
            end
        end
    end

    local dealNum = math.min(16, #itemPool, #slotList)
    local publicService = GAME:getPublicService()
    for idx = 1, dealNum do
        local itemIdx = math.random(1, #itemPool)
        local item = table.remove(itemPool, itemIdx)
        local slot = slotList[idx]
        if slot then
            local pos = slot:getPosition()
            if not pos then
                error("fatal error: bp display slot position is nil")
            end
            local isFlip = true
            if item.flip ~= nil then isFlip = item.flip end
            local rot = isFlip and __CARD_ROTATION_FACE_UP or __CARD_ROTATION_FACE_DOWN
            local deck = publicService:getDevDeck(item.prefix)
            if not deck or not isCardLike(deck) then
                error("fatal error: dev deck " .. tostring(item.prefix) .. " is not found")
            end
            local clonedObject = deck.clone({position = pos, rotation = rot})
            local takeParam = {index = item.index - 1, position = pos, rotation = rot}
            clonedObject.takeObject(takeParam).setLock(true)
            local remnantObject = clonedObject.remainder and clonedObject.remainder or clonedObject
            remnantObject.destruct()
        end
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