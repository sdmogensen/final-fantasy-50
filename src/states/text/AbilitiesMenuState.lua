AbilitiesMenuState = Class{__includes = BaseState}

function AbilitiesMenuState:init(battleState)
    self.battleState = battleState
    self.battleState.canInput = true

    local items = {}
    for k, ability in pairs(self.battleState.currentAttacker.abilities) do
        local abilityName = ability[1]
        local abilityCost = ability[2]
        local abilityType = ability[3]
        local pointType = self.battleState.currentAttacker.MP and 'MP' or 'AP'
        local text = abilityName .. ' ' .. pointType .. tostring(abilityCost)
        local onSelect = function()
            -- if we don't have enough MP/AP, warn the player
            if pointType == 'MP' and self.battleState.currentAttacker.MP < abilityCost then
                gStateStack:push(BattleMessageState('Not enough MP!'))
            elseif pointType == 'AP' and self.battleState.currentAttacker.AP < abilityCost then
                gStateStack:push(BattleMessageState('Not enough AP!'))
            elseif abilityType == 'all' then
                -- don't allow the player to input any more commands until next turn
                self.battleState.canInput = false
                self.battleState:performAction(self.battleState.currentAttacker, nil, abilityName, abilityCost)
            else
                -- hide this menu and load the next menu
                self.battleMenu.showMenu = false
                gStateStack:push(ChooseCombatantState(self.battleState, abilityName, abilityCost, abilityType))
            end
        end
        table.insert(items, {text = text, onSelect = onSelect})
    end

    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - ABILITY_MENU_WIDTH,
        y = VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT,
        width = ABILITY_MENU_WIDTH,
        height = BATTLE_MENU_HEIGHT,
        items = items
    }
end

function AbilitiesMenuState:update(dt)
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

function AbilitiesMenuState:render()
    self.battleMenu:render()
end
