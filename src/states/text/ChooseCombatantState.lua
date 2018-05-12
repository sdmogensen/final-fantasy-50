--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ChooseCombatantState = Class{__includes = BaseState}

function ChooseCombatantState:init(battleState, actionName, actionCost, actionType)
    self.battleState = battleState

    local items = {}
    -- actionType is either 'ally' or 'enemy'
    local combatants = actionType == 'ally' and self.battleState.players or self.battleState.enemies
    for k, combatant in pairs(combatants) do
        if not combatant.dead then
            local text = combatant.name
            local onSelect = function()
                -- don't allow the player to input any more commands until next turn
                self.battleState.canInput = false
                self.battleState:performAction(self.battleState.currentAttacker, combatant, actionName, actionCost)
            end
            table.insert(items, {text = text, onSelect = onSelect})
        end
    end

    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - BATTLE_MENU_WIDTH,
        y = VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT,
        width = BATTLE_MENU_WIDTH,
        height = BATTLE_MENU_HEIGHT,
        items = items
    }
end

function ChooseCombatantState:update(dt)
    if self.battleState.canInput then
        self.battleMenu:update(dt)
        if love.keyboard.wasPressed('lshift') or love.keyboard.wasPressed('rshift') then
            gSounds['blip']:stop()
            gSounds['blip']:play()
            gStateStack:pop()
        end
    end
end

function ChooseCombatantState:render()
    self.battleMenu:render()
end
