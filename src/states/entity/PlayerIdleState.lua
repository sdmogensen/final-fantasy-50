--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(entity, NPCs)
    self.entity = entity
    self.NPCs = NPCs
    self.entity:changeAnimation('idle-' .. self.entity.direction)
end

function PlayerIdleState:update(dt)
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
    end
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        facingX = self.entity.mapX
        facingY = self.entity.mapY
        if self.entity.direction == 'left' then
            facingX = facingX - 1
        elseif self.entity.direction == 'right' then
            facingX = facingX + 1
        elseif self.entity.direction == 'up' then
            facingY = facingY - 1
        else
            facingY = facingY + 1
        end
        for k, NPC in pairs(self.NPCs) do
            if NPC.mapX == facingX and NPC.mapY == facingY then
                NPC:onInteract(self.entity.direction)
            end
        end
    end
end
