Dragon = Class{}

function Dragon:init(mapX, mapY)
    self.mapX = mapX
    self.mapY = mapY
end

function Dragon:onInteract(overworldState)
    -- if we've interacted with the dragon in the overworld, trigger the final boss battle
    gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
    function()
        gSounds['dungeon-theme']:stop()
        gStateStack:push(BattleState(overworldState.players, overworldState.items, 'dragon'))
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
    end))
end

function Dragon:render()
    love.graphics.draw(gTextures['dragon'], (self.mapX - 1) * TILE_SIZE, (self.mapY - 1) * TILE_SIZE, 0, 0.5)
end
