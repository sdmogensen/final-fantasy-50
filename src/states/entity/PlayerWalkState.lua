--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(entity, map, NPCs)
    self.entity = entity
    self.map = map
    self.NPCs = NPCs
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

    local isNPC = false
    for k, NPC in pairs(self.NPCs) do
        if NPC.mapX == toX and NPC.mapY == toY then
            isNPC = true
            break
        end
    end

    -- break out if we try to move out of the map boundaries or have a collision
    if isNPC or toX < 1 or toX > self.map.width or toY < 1 or toY > self.map.height
        or self.map.collisionLayer[toX + self.map.width * (toY - 1)] > 0 then
        self.entity:changeState('idle')
        self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
        return
    end

    self.entity.mapX = toX
    self.entity.mapY = toY

    Timer.tween(10/PLAYER_SPEED, {
        [self.entity] = {x = (toX - 1) * TILE_SIZE, y = (toY - 1) * TILE_SIZE - TILE_SIZE/3}
    }):finish(function()
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
    end)
end
