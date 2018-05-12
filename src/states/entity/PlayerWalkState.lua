PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, overworldState)
    self.entity = player
    self.overworldState = overworldState
    self.map = self.overworldState.map
    self.area = self.overworldState.area
end

function PlayerWalkState:enter()
    self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))

    local toX, toY = self.entity.mapX, self.entity.mapY

    if self.entity.direction == 'left' then
        toX = toX - 1
    elseif self.entity.direction == 'right' then
        toX = toX + 1
    elseif self.entity.direction == 'up' then
        toY = toY - 1
    else
        toY = toY + 1
    end

    -- check if there is an NPC, chest, or object in the way
    local isObstacle = false
    for k, NPC in pairs(self.overworldState.NPCs) do
        if NPC.mapX == toX and NPC.mapY == toY then
            isObstacle = true
            break
        end
    end
    if not isObstacle then
        for k, chest in pairs(self.overworldState.chests) do
            if chest.mapX == toX and chest.mapY == toY then
                isObstacle = true
                break
            end
        end
    end
    if not isObstacle then
        for k, object in pairs(self.overworldState.objects) do
            if object.mapX == toX and object.mapY == toY then
                isObstacle = true
                break
            end
        end
    end

    -- change back to idle if we try to move out of the map boundaries or have a collision
    if isObstacle or toX < 1 or toX > self.map.width or toY < 1 or toY > self.map.height
        or self.map.collisionLayer[toX + self.map.width * (toY - 1)] > 0 then

        self.entity:changeState('idle')
        self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
        return
    end

    self.entity.mapX = toX
    self.entity.mapY = toY

    -- check if we need to transition into a new location
    local changedLocation = self.overworldState:checkForLocationChange(toX, toY)

    Timer.tween(10/PLAYER_SPEED, {
        [self.entity] = {x = (toX - 1) * TILE_SIZE, y = (toY - 1) * TILE_SIZE - TILE_SIZE/3}
    }):finish(function()
        -- 1 chance in 20 of triggering a battle either in the overworld or dungeon areas
        if not changedLocation and self.area == 'overworld' and math.random(20) == 1 then
            self.entity:changeState('idle')
            self:initiateBattle('overworld')
        elseif not changedLocation and (self.area == 'dungeon' or self.area == 'dungeon-lv2') and math.random(20) == 1 then
            self.entity:changeState('idle')
            self:initiateBattle('dungeon')
        else
            -- if we have not transitioned to a new area and we have not triggered a battle, check for new direction
            if love.keyboard.isDown('left') then
                self.entity.direction = 'left'
                self.entity:changeState('walk')
            elseif love.keyboard.isDown('right') then
                self.entity.direction = 'right'
                self.entity:changeState('walk')
            elseif love.keyboard.isDown('up') then
                self.entity.direction = 'up'
                self.entity:changeState('walk')
            elseif love.keyboard.isDown('down') then
                self.entity.direction = 'down'
                self.entity:changeState('walk')
            else
                self.entity:changeState('idle')
            end
        end
    end)
end

function PlayerWalkState:initiateBattle(area)
    -- define potential enemies for each area
    local potentialEnemies = {}
    if area == 'overworld' then
        potentialEnemies = {'slime', 'bat'}
    else
        potentialEnemies = {'skeleton', 'ghost', 'spider'}
    end

    -- add 2 to 4 of these to the list of enemies we will face
    local numEnemies = math.random(2, 4)
    local enemies = {}
    for i = 1, numEnemies do
        table.insert(enemies, potentialEnemies[math.random(1, #potentialEnemies)])
    end

    -- push the battle state
    gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
    function()
        gSounds[area .. '-theme']:pause()
        gStateStack:push(BattleState(self.overworldState.players, self.overworldState.items, enemies, area))
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
    end))
end
