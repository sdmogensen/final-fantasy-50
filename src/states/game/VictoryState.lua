VictoryState = Class{__includes = BaseState}

function VictoryState:init()
    gSounds['endcredits']:setLooping(true)
    gSounds['endcredits']:play()
    self.text_y = VIRTUAL_HEIGHT
    self.text_opacity = 0
    self.canInput = false

    -- scroll the ending message
    Timer.tween(20, {
        [self] = {text_y = -VIRTUAL_HEIGHT}
    }):finish(function()
        self.canInput = true
        Timer.tween(2, {
            [self] = {text_opacity = 255}
        })
    end)
end

function VictoryState:update(dt)
    if self.canInput then
        if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
            function()
                gSounds['endcredits']:stop()
                gStateStack:pop()
                gStateStack:push(StartState())
                gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
            end))
        end
    end
end

function VictoryState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['fortress_background'], 0, 0, 0,
        VIRTUAL_WIDTH / gTextures['fortress_background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['fortress_background']:getHeight())

    local shadow = 1
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Congratulations!', 0 + shadow, self.text_y + shadow, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Congratulations!', 0, self.text_y, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('You have beaten the dragon and freed the land from his evil oppression', VIRTUAL_WIDTH / 8 + shadow, self.text_y + VIRTUAL_WIDTH / 5 + shadow, VIRTUAL_WIDTH * 3 / 4, 'center')
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('You have beaten the dragon and freed the land from his evil oppression', VIRTUAL_WIDTH / 8, self.text_y + VIRTUAL_WIDTH / 5, VIRTUAL_WIDTH * 3 / 4, 'center')

    love.graphics.setColor(255, 255, 255, self.text_opacity)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Thanks for playing!', 0 + shadow, 32 + shadow, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 0, 0, self.text_opacity)
    love.graphics.printf('Thanks for playing!', 0, 32, VIRTUAL_WIDTH, 'center')
end
