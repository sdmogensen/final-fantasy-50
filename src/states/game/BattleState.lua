BattleState = Class{__includes = BaseState}

function BattleState:init(players, items, enemyNames, area)
    self.players = players
    self.items = items
    self.area = area
    self.enemies = {}
    self.nextTurnReady = true
    self.canInput = true
    self.expToGain = 0

    -- this is a regular battle if we are not facing the dragon
    self.regularBattle = not (enemyNames == 'dragon')

    if self.regularBattle then
        gSounds['battle-theme']:setLooping(true)
        gSounds['battle-theme']:play()
        -- add enemies to the field
        for k, enemyName in pairs(enemyNames) do
            local enemy = Enemy({ name = enemyName, enemy_num = k })
            table.insert(self.enemies, enemy)
            -- add up the exp that the players will receive from this battle
            self.expToGain = self.expToGain + enemy.exp
        end
    else
        gSounds['dragon-theme']:setLooping(true)
        gSounds['dragon-theme']:play()
        table.insert(self.enemies, Enemy({ name = 'dragon' }))
    end

    -- bottom left panel that shows the enemies we are still facing
    self:updateEnemyPanel()
    -- bottom panel that shows player info
    self.playerPanel = Panel(VIRTUAL_WIDTH / 6, VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT, VIRTUAL_WIDTH * 5 / 6, BATTLE_MENU_HEIGHT)

    -- potential items that we can steal or get from winning the battle
    self.potentialItems = {{name = 'elixir', likelihood = 10}, {name = 'ether', likelihood = 30}, {name = 'potion', likelihood = 70}}
end

function BattleState:enter()
    if self.regularBattle then
        gStateStack:push(BattleMessageState('The enemy attacks!'))
    else
        gStateStack:push(BattleMessageState('The dragon attacks!!'))
    end
end

function BattleState:update(dt)
    -- if we are ready for the next turn, set the next attacker
    if self.nextTurnReady then
        self.nextTurnReady = false
        self.canInput = true
        self:setNextAttacker()
        self.currentAttacker.tookTurn = true
        -- if we are the next attacker, open battle menu
        if self.currentAttacker.isPlayer then
            gStateStack:push(BattleMenuState(self))
        else
            -- if an enemy is next, randomly choose non dead player to attack
            defender = self.players[math.random(1, #self.players)]
            while (defender.dead) do
                defender = self.players[math.random(1, #self.players)]
            end
            self:performAttack(self.currentAttacker, defender)
        end
    end
end

function BattleState:setNextAttacker()
    self.currentAttacker = nil
    local topSpeed = 0
    -- set currentAttacker to the fastest player or enemy who has not taken their turn
    for k, player in pairs(self.players) do
        if not player.dead and not player.tookTurn and player.speed > topSpeed then
            self.currentAttacker = player
            topSpeed = player.speed
        end
    end
    for k, enemy in pairs(self.enemies) do
        if not enemy.tookTurn and enemy.speed > topSpeed then
            self.currentAttacker = enemy
            topSpeed = enemy.speed
        end
    end

    -- if everyone has taken their turn, reset all combatants tookTurn flag and recurse
    if not self.currentAttacker then
        for k, player in pairs(self.players) do
            player.tookTurn = false
        end
        for k, enemy in pairs(self.enemies) do
            enemy.tookTurn = false
        end
        self:setNextAttacker()
    end
end

function BattleState:updateEnemyPanel()
    local enemyList = ''
    for k, enemy in pairs(self.enemies) do
        if enemy.HP > 0 then
            enemyList = enemyList .. enemy.name .. '\n'
        end
    end
    self.enemyPanel = Textbox(0, VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT, VIRTUAL_WIDTH / 6, BATTLE_MENU_HEIGHT, enemyList, 4)
end

function BattleState:performAction(combatantFrom, combatantTo, name, cost)
    -- heal amount or damage amount is based on the player's level
    local amount = math.floor(45 + combatantFrom.level * 10 + math.random() * 10)

    -- based on the action name, dispatch action to the proper fucntion
    if name == 'attack' then
        self:performAttack(combatantFrom, combatantTo)
    elseif name == 'item' then
        self:useItem(combatantFrom, combatantTo, cost)
    elseif name == 'Steal' then
        self:stealItem(combatantFrom, combatantTo, cost)
    elseif name == 'Cure' then
        self:performEffectOnCombatant(combatantFrom, combatantTo, name, cost, 'heal', math.floor(amount * 1.5))
    elseif name == 'Curaga' then
        self:performEffectOnAll(combatantFrom, 'ally', name, cost, 'heal', math.floor(amount * 1.5))
    elseif name == 'Fire' then
        self:performEffectOnCombatant(combatantFrom, combatantTo, name, cost, 'fire', amount)
    elseif name == 'Firaga' then
        self:performEffectOnAll(combatantFrom, 'enemy', name, cost, 'fire', amount)
    elseif name == 'Blizzard' then
        self:performEffectOnCombatant(combatantFrom, combatantTo, name, cost, 'freeze', amount)
    elseif name == 'Blizzaga' then
        self:performEffectOnAll(combatantFrom, 'enemy', name, cost, 'freeze', amount)
    elseif name == 'Sidewinder' then
        self:performEffectOnCombatant(combatantFrom, combatantTo, name, cost, 'spell', amount)
    elseif name == 'Sonic Boom' then
        self:performEffectOnAll(combatantFrom, 'enemy', name, cost, 'spell', amount)
    end
end

function BattleState:useItem(combatantFrom, combatantTo, item)
    gStateStack:push(BattleMessageState(combatantFrom.name .. ' uses a ' .. item.name .. ' on ' .. combatantTo.name .. '.', function() end, 1.1))
    gSounds['powerup']:play()
    combatantFrom.battleSprite:blinkWhite(12, function()
        -- consume the item and remove it from inventory
        item.onConsume(combatantTo)
        for k, itemElement in pairs(self.items) do
            if item.name == itemElement.name then
                table.remove(self.items, k)
                break
            end
        end
        combatantTo.battleSprite:blinkTransparent(18, function()
            -- remove 3 layers of menus
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:pop()
            self.nextTurnReady = true
        end)
    end)
end

function BattleState:stealItem(combatantFrom, combatantTo, cost)
    local gainedItem = self:getPotentialItem()
    gStateStack:push(BattleMessageState(combatantFrom.name .. ' attempts to steal from ' .. combatantTo.name .. '.', function() end, 1.1))
    gSounds['powerup']:play()
    combatantFrom.battleSprite:blinkWhite(12, function()
        if gainedItem then
            gStateStack:push(BattleMessageState(combatantFrom.name .. ' stole ' .. gainedItem.article .. ' ' .. gainedItem.name .. '!', function() end, 1.7))
            gSounds['run']:play()
        else
            gStateStack:push(BattleMessageState(combatantFrom.name .. ' failed to steal anything.', function() end, 1.7))
        end
        combatantTo.battleSprite:blinkTransparent(18, function()
            -- remove 3 layers of menus
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:pop()
            combatantFrom.AP = combatantFrom.AP - cost
            if gainedItem then
                table.insert(self.items, gainedItem)
            end
            self.nextTurnReady = true
        end)
    end)
end

function BattleState:getPotentialItem()
    -- return item from the potentialItems list based on likelihoods
    local itemChance = math.random(1,100)
    local gainedItem = nil
    for k, itemInfo in pairs(self.potentialItems) do
        if itemChance < itemInfo.likelihood then
            return Item(itemInfo.name)
        end
    end
    return nil
end

--[[
    Perform the given action on the given combatant
]]
function BattleState:performEffectOnCombatant(combatantFrom, combatantTo, effecName, cost, effectType, amount)
    local pointType = combatantFrom.MP and 'MP' or 'AP'
    gStateStack:push(BattleMessageState(combatantFrom.name .. ' performs ' .. effecName .. ' on ' .. combatantTo.name .. '.', function() end, 1.1))
    gSounds['powerup']:play()
    combatantFrom.battleSprite:blinkWhite(12, function()
        if effectType == 'heal' then
            gStateStack:push(BattleMessageState(combatantTo.name .. ' heals ' .. tostring(amount) .. ' HP.', function() end, 1.7))
        else
            gStateStack:push(BattleMessageState(combatantTo.name .. ' takes ' .. tostring(amount) .. ' damage.', function() end, 1.7))
        end
        gSounds[effectType]:play()
        combatantTo.battleSprite:blinkTransparent(18, function()
            -- remove 3 layers of menus
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:pop()
            -- decrement correct point type
            if pointType == 'MP' then
                combatantFrom.MP = combatantFrom.MP - cost
            else
                combatantFrom.AP = combatantFrom.AP - cost
            end
            -- depending on effect type, heal combatant or take damage
            if effectType == 'heal' then
                combatantTo.HP = math.min(combatantTo.maxHP, combatantTo.HP + amount)
                self.nextTurnReady = true
            else
                self:takeDamage(combatantTo, amount)
                -- only players can damage combatants with a spell, so remove dead enemies
                self:removeDeadEnemies()
            end
        end)
    end)
end

--[[
    Perform the given action on all enemies
]]
function BattleState:performEffectOnAll(combatantFrom, combatantsTo, effecName, cost, effectType, amount)
    gStateStack:push(BattleMessageState(combatantFrom.name .. ' performs ' .. effecName .. '!', function() end, 1.1))
    gSounds['powerup']:play()
    combatantFrom.battleSprite:blinkWhite(12, function()
        if effectType == 'heal' then
            gStateStack:push(BattleMessageState('Everyone heals ' .. tostring(amount) .. ' HP.', function() end, 1.7))
        else
            gStateStack:push(BattleMessageState('Everyone takes ' .. tostring(amount) .. ' damage.', function() end, 1.7))
        end
        gSounds[effectType]:play()
        local firstCombatantBlinked = false
        local combatants = combatantsTo == 'ally' and self.players or self.enemies
        for k, combatant in pairs(combatants) do
            if not combatant.dead then
                if firstCombatantBlinked then
                    combatant.battleSprite:blinkTransparent(18, function ()
                        -- depending on effect type, heal combatant or take damage
                        if effectType == 'heal' then
                            combatant.HP = math.min(combatant.maxHP, combatant.HP + amount)
                        else
                            self:takeDamage(combatant, amount)
                        end
                    end)
                else
                    -- ensure that these actions only happen for the first combatant
                    firstCombatantBlinked = true
                    combatant.battleSprite:blinkTransparent(18, function()
                        -- only remove 2 layers of menus
                        gStateStack:pop()
                        gStateStack:pop()
                        -- decrement correct point type
                        if combatantFrom.MP then
                            combatantFrom.MP = combatantFrom.MP - cost
                        else
                            combatantFrom.AP = combatantFrom.AP - cost
                        end
                        -- depending on effect type, heal combatant or take damage
                        if effectType == 'heal' then
                            combatant.HP = math.min(combatant.maxHP, combatant.HP + amount)
                            self.nextTurnReady = true
                        else
                            self:takeDamage(combatant, amount)
                            -- only players can damage combatants with a spell, so remove dead enemies
                            self:removeDeadEnemies()
                        end
                    end)
                end
            end
        end
    end)
end

function BattleState:performAttack(attacker, defender)
    -- damage dealt is calculated based on attacker's attack stat and the defender's defense stat
    local damageDealt = math.max(10, math.floor(attacker.attack * (3 + math.random()) - defender.defense * 1.5))
    -- move the attacker in a different direction based on whether it is a player ot not
    local movement = attacker.isPlayer and 30 or -30
    gStateStack:push(BattleMessageState(attacker.name .. ' deals ' .. tostring(damageDealt) .. ' damage to ' .. defender.name .. '!', function() end, 1.5))
    attacker.battleSprite:move(-movement, function()
        gSounds['powerup']:play()
        attacker.battleSprite:blinkWhite(6, function()
            gSounds['hit']:play()
            defender.battleSprite:blinkTransparent(6, function()
                attacker.battleSprite:move(movement, function()
                    if attacker.isPlayer then
                        -- remove 2 layers of menus
                        gStateStack:pop()
                        gStateStack:pop()
                    end
                    self:takeDamage(defender, damageDealt)
                    if attacker.isPlayer then
                        -- if an enemy was attacked, remove dead enemies
                        self:removeDeadEnemies()
                    end
                end)
            end)
        end)
    end)
end

function BattleState:takeDamage(combatant, damage)
    combatant.HP = math.max(0, combatant.HP - damage)
    if combatant.HP == 0 then
        combatant.dead = true
        if combatant.isPlayer then
            -- if the dead combatant is a player, fade them out and check for defeat
            gStateStack:push(BattleMessageState(combatant.name .. ' has fainted!', function() end, 1.5))
            gSounds['death']:play()
            combatant.battleSprite:fadeOut(function()
                self:CheckForDefeat()
                self.nextTurnReady = true
            end)
        end
    -- only toggle nextTurnReady if a player was damaged because otherwise
    -- this should be set in the removeDeadEnemies() function
    elseif combatant.isPlayer then
        self.nextTurnReady = true
    end
end

function BattleState:removeDeadEnemies()
    -- if there are no more enemies, trigger battleWon
    if #self.enemies == 0 then
        self:battleWon()
    end
    for k, enemy in pairs(self.enemies) do
        if enemy.dead then
            -- if we find a dead enemy, fade them out and recurse
            gStateStack:push(BattleMessageState(enemy.name .. ' has been defeated!', function() end, 1.5))
            gSounds['death']:play()
            enemy.battleSprite:fadeOut(function()
                table.remove(self.enemies, k)
                self:removeDeadEnemies()
            end)
            return
        end
    end
    self:updateEnemyPanel()
    self.nextTurnReady = true
end

function BattleState:CheckForDefeat()
    for k, player in pairs(self.players) do
        if not player.dead then
            -- return if we find a player who is not dead
            return
        end
    end
    -- if all players are dead, switch to game over state
    gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
    function()
        -- remove battle state and overworld state
        gStateStack:pop()
        gStateStack:pop()
        if self.regularBattle then
            gSounds['battle-theme']:stop()
        else
            gSounds['dragon-theme']:stop()
        end
        gStateStack:push(GameOverState())
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
    end))
end

function BattleState:battleWon()
    -- if this was the final boss battle, switch to victory state
    if not self.regularBattle then
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
        function()
            -- remove battle state and overworld state
            gStateStack:pop()
            gStateStack:pop()
            gSounds['dragon-theme']:stop()
            gStateStack:push(VictoryState())
            gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
        end))
        return
    end

    gSounds['battle-theme']:stop()
    gSounds['victory-theme']:play()

    local lastMessagePushed = false
    for i = #self.players, 1, -1  do
        self.players[i].tookTurn = false
        -- only give player exp if they are alive
        if not self.players[i].dead then
            self.players[i]:addExp(self.expToGain)
            if self.players[i].hasLeveled then
                self.players[i].hasLeveled = false
                if not lastMessagePushed then
                    lastMessagePushed = true
                    gStateStack:push(BattleMessageState(self.players[i].name .. ' has leveled up to level ' .. tostring(self.players[i].level) .. "!", function()
                        -- only transition out of the battle after the last message has been cleared
                        self:transitionOutOfBattle()
                    end))
                else
                    gStateStack:push(BattleMessageState(self.players[i].name .. ' has leveled up to level ' .. tostring(self.players[i].level) .. "!"))
                end
            end
        end
    end
    if not lastMessagePushed then
        gStateStack:push(BattleMessageState('Gained ' .. self.expToGain .. ' experience.', function()
            -- only transition out of the battle after the last message has been cleared
            self:transitionOutOfBattle()
        end))
    else
        gStateStack:push(BattleMessageState('Gained ' .. self.expToGain .. ' experience.'))
    end
    -- potentially gain an item from the battle
    local gainedItem = self:getPotentialItem()
    if gainedItem then
        gStateStack:push(BattleMessageState('Got ' .. gainedItem.article .. ' ' .. gainedItem.name .. '!'))
        table.insert(self.items, gainedItem)
    end
end

function BattleState:transitionOutOfBattle()
    gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED, function()
        -- remove battle state
        gStateStack:pop()
        gSounds['victory-theme']:stop()
        gSounds[self.area .. '-theme']:resume()
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
    end))
end

function BattleState:render()
    love.graphics.setColor(255, 255, 255, 255)
    -- render different background depending on the area
    if self.area == 'overworld' then
        love.graphics.draw(gTextures['grass_background'], 0, -30, 0,
            VIRTUAL_WIDTH / gTextures['grass_background']:getWidth(),
            VIRTUAL_HEIGHT / gTextures['grass_background']:getHeight())
    else
        love.graphics.draw(gTextures['cave_background'], 0, -20, 0,
            VIRTUAL_WIDTH / gTextures['cave_background']:getWidth(),
            VIRTUAL_HEIGHT / gTextures['cave_background']:getHeight())
    end
    self.enemyPanel:render()
    self.playerPanel:render()
    -- render all enemy battle sprites
    for k, enemy in pairs(self.enemies) do
        enemy.battleSprite:render()
    end
    for k, player in pairs(self.players) do
        player.battleSprite:render()
        -- if the player is the current attacker, highlight their name in yellow
        if self.currentAttacker == player then
            love.graphics.setColor(255, 255, 0, 255)
        -- if the player is dead, gray their name out
        elseif player.dead then
            love.graphics.setColor(128, 128, 128, 255)
        else
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.print(player.name, VIRTUAL_WIDTH / 6 + 6, VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT + 3 + (k - 1) * 16)
        -- display the player's HP
        love.graphics.print('HP: ' .. tostring(player.HP) .. '/' .. tostring(player.maxHP), VIRTUAL_WIDTH / 6+ 65, VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT + 3 + (k - 1) * 16)
        -- display the player's MP/AP
        if player.MP then
            love.graphics.print('MP: ' .. tostring(player.MP) .. '/' .. tostring(player.maxMP), VIRTUAL_WIDTH / 6 + 145, VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT + 3 + (k - 1) * 16)
        elseif player.AP then
            love.graphics.print('AP: ' .. tostring(player.AP) .. '/' .. tostring(player.maxAP), VIRTUAL_WIDTH / 6 + 145, VIRTUAL_HEIGHT - BATTLE_MENU_HEIGHT + 3 + (k - 1) * 16)
        end
    end
end
