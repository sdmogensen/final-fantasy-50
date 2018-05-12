--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState)
    self.battleState = battleState
    local items = {
        {
            text = 'Fight',
            onSelect = function()
                -- hide this menu and load the next menu
                self.battleMenu.showMenu = false
                gStateStack:push(ChooseCombatantState(self.battleState, 'attack', nil, 'enemy'))
            end
        }
    }

    -- only show the Magic/Ability option if the player type has it
    if self.battleState.currentAttacker.abilityType then
        table.insert(items, {
            text = self.battleState.currentAttacker.abilityType,
            onSelect = function()
                -- hide this menu and load the next menu
                self.battleMenu.showMenu = false
                gStateStack:push(AbilitiesMenuState(self.battleState))
            end
        })
    end

    table.insert(items, {
        text = 'Item',
        onSelect = function()
            if #self.battleState.items == 0 then
                gStateStack:push(BattleMessageState('You have no items!'))
            else
                -- hide this menu and load the next menu
                self.battleMenu.showMenu = false
                gStateStack:push(ItemMenuState(self.battleState))
            end
        end
    })

    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - BATTLE_MENU_WIDTH,
        y = VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT,
        width = BATTLE_MENU_WIDTH,
        height = BATTLE_MENU_HEIGHT,
        items = items
    }
end

function BattleMenuState:update(dt)
    self.battleMenu.showMenu = true
    self.battleMenu:update(dt)
end

function BattleMenuState:render()
    self.battleMenu:render()
end
