ItemMenuState = Class{__includes = BaseState}

function ItemMenuState:init(battleState)
    self.battleState = battleState

    -- count up the total number of items of each type for display purposes
    local itemMenu = {}
    for k, item in pairs(self.battleState.items) do
        self:add_item(itemMenu, item)
    end

    local items = {}
    for k, itemInfo in pairs(itemMenu) do
        local text = itemInfo.name .. ' (' .. tostring(itemInfo.count) .. ')'
        local onSelect = function()
            -- don't allow the player to input any more commands until next turn
            self.battleMenu.showMenu = false
            gStateStack:push(ChooseCombatantState(self.battleState, 'item', itemInfo.item, 'ally'))
        end
        table.insert(items, {text = text, onSelect = onSelect})
    end

    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - BATTLE_MENU_WIDTH,
        y = VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT,
        width = BATTLE_MENU_WIDTH,
        height = BATTLE_MENU_HEIGHT,
        items = items
    }
end

function ItemMenuState:add_item (itemMenu, item)
    -- if the item is in the itemMenu, increment its count
    for k, itemInfo in pairs(itemMenu) do
        if itemInfo.name == item.name then
            itemInfo.count = itemInfo.count + 1
            return
        end
    end
    -- otherwise create a new entry in the itemMenu
    table.insert(itemMenu, {item = item, name = item.name, count = 1})
end

function ItemMenuState:update(dt)
    if self.battleState.canInput then
        self.battleMenu.showMenu = true
        self.battleMenu:update(dt)
        if love.keyboard.wasPressed('lshift') or love.keyboard.wasPressed('rshift') then
            gSounds['blip']:stop()
            gSounds['blip']:play()
            gStateStack:pop()
        end
    end
end

function ItemMenuState:render()
    self.battleMenu:render()
end
