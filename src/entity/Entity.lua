Entity = Class{}

function Entity:init(def)
    self.direction = 'down'

    if (def.mapX and def.mapY) then
        self:setMapPosition(def.mapX, def.mapY)
    end
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:createAnimations(animations, texture)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = texture,
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Entity:setMapPosition(mapX, mapY)
    self.mapX = mapX
    self.mapY = mapY

    self.x = (self.mapX - 1) * TILE_SIZE
    -- slightly raised on the tile to simulate height/perspective
    self.y = (self.mapY - 1) * TILE_SIZE - TILE_SIZE/3
end

function Entity:onInteract()
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:update(dt)
    self.currentAnimation:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()
    self.stateMachine:render()
end
