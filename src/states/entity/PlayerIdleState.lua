PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player, overworldState)
    self.entity = player
    self.overworldState = overworldState
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
        -- calculate the map coordinates that we are facing
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
        -- if we are facing an NPC, trigger onInteract
        for k, NPC in pairs(self.overworldState.NPCs) do
            if NPC.mapX == facingX and NPC.mapY == facingY then
                NPC:onInteract(self.entity.direction)
            end
        end
        -- if we are facing a chest, trigger open
        for k, chest in pairs(self.overworldState.chests) do
            if chest.mapX == facingX and chest.mapY == facingY then
                chest:open()
            end
        end
        -- if we are facing an object, trigger onInteract
        for k, object in pairs(self.overworldState.objects) do
            if object.mapX == facingX and object.mapY == facingY then
                object:onInteract()
            end
        end
        -- if we are facing the dragon (whose dimensions are 3x5), trigger onInteract
        local dragon = self.overworldState.dragon
        if dragon and facingX >= dragon.mapX and facingX <= (dragon.mapX + 4) and facingY >= dragon.mapY and facingY <= ( dragon.mapY + 2) then
            dragon:onInteract(self.overworldState)
        end
    end
end
