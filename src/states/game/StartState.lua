StartState = Class{__includes = BaseState}

function StartState:init()
    gSounds['intro-theme']:setLooping(true)
    gSounds['intro-theme']:play()
    self.sword_x = -VIRTUAL_WIDTH
    self.text1_opacity = 0
    self.text2_opacity = 0
    self.text3_opacity = 0

    -- animate the intro
    Timer.tween(1.5, {
        [self] = {sword_x = 48}
    }):finish(function()
        Timer.tween(3, {
            [self] = {text1_opacity = 255}
        }):finish(function()
            Timer.tween(1, {
                [self] = {text2_opacity = 255}
            }):finish(function()
                Timer.tween(1, {
                    [self] = {text3_opacity = 255}
                })
            end)
        end)
    end)
end

function StartState:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
        function()
            gStateStack:pop()
            gStateStack:push(CharacterSelectState())
            gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
        end))
    end
end

function StartState:render()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['background'], 0, 0, 0,
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    love.graphics.draw(gTextures['sword'], self.sword_x, VIRTUAL_HEIGHT / 2 - 36, 0, 0.12)

    local shadow = 0.8
    love.graphics.setColor(255, 255, 255, self.text1_opacity)
    love.graphics.setFont(gFonts['finalf'])
    love.graphics.printf('FINAL FANTASY', 16 + shadow, 26 + shadow, VIRTUAL_WIDTH, 'left')
    love.graphics.setFont(gFonts['extra-large'])
    love.graphics.printf('50', -16 + shadow, 0 + shadow, VIRTUAL_WIDTH, 'right')
    love.graphics.setColor(0, 0, 0, self.text1_opacity)
    love.graphics.setFont(gFonts['finalf'])
    love.graphics.printf('FINAL FANTASY', 16, 26, VIRTUAL_WIDTH, 'left')
    love.graphics.setFont(gFonts['extra-large'])
    love.graphics.printf('50', -16, 0, VIRTUAL_WIDTH, 'right')

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255, 255, 255, self.text2_opacity)
    love.graphics.printf('Project by: Stephen Mogensen', 0 + shadow, VIRTUAL_HEIGHT / 2 + 32 + shadow, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 0, 0, self.text2_opacity)
    love.graphics.printf('Project by: Stephen Mogensen', 0, VIRTUAL_HEIGHT / 2 + 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(255, 255, 255, self.text3_opacity)
    love.graphics.printf('Press Enter', 0 + shadow, VIRTUAL_HEIGHT / 2 + 68 + shadow, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 0, 0, self.text3_opacity)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 68, VIRTUAL_WIDTH, 'center')
end
