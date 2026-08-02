require("mock/default")
require("com/const")
require("com/enum_const")
require("com/const_bp_display_board")
require("com/const_display_board")
require("com/basic")

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
    local maxRoleNum = 16
    local zone = getBpDisplayZone()
    local slotList = zone.display_slots or {}

    --- if no slot, return directly
    if #slotList == 0 then return end

    --- if all slots are occupied, return directly
    local blankSlot = {}
    for index = 1, math.min(maxRoleNum, #slotList) do
        local slot = slotList[index]
        if slot and slot:getCardObject() == nil then
            table.insert(blankSlot, index)
        end
    end
    local dealNum = #blankSlot
    if dealNum == 0 then return end

    --- build-up a random role pool
    local rolePool = {}
    for roleKey, _ in pairs(ROLE_REGISTER_DICT) do
        table.insert(rolePool, roleKey)
    end
    local randomRolePool = getRandomSubset(rolePool, dealNum)

    --- check if equal
    if #randomRolePool ~= dealNum then error("fatal error: role pool is not equal") end

    local publicService = GAME:getPublicService()
    for index, roleKey in ipairs(randomRolePool) do
        local slotIndex = blankSlot[index]
        local slot = slotList[slotIndex]
        local roleData = ROLE_REGISTER_DICT[roleKey] or {}
        local roleItem = roleData[KWORD_ITEM] or {}
        local item = roleItem[1] or {}
        if item.origin ~= EnumItemOrigin.DEV_DECK then
            error("fatal error: character card "..roleKey.." is not from dev deck")
        end
        local isFlip = true
        if item.flip ~= nil then isFlip = item.flip end
        local rot = isFlip and __CARD_ROTATION_FACE_UP or __CARD_ROTATION_FACE_DOWN
        local pos = slot:getPosition()
        local deck = publicService:getDevDeck(item.prefix)
        if not deck then error("fatal error: could not find dev deck "..item.prefix) end

        ---- clone a card from dev deck
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