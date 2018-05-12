FadeState = Class{__includes = BaseState}

function FadeState:init(color, opacity, time, onFadeComplete)
    self.r = color.r
    self.g = color.g
    self.b = color.b
    self.opacity = opacity.from
    self.time = time
    self.onFadeComplete = onFadeComplete or function() end

    Timer.tween(self.time, {
        [self] = {opacity = opacity.to}
    })
    :finish(function()
        gStateStack:pop()
        self.onFadeComplete()
    end)
end

function FadeState:render()
    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH*2, VIRTUAL_HEIGHT*2)
end
