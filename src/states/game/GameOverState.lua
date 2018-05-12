GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    gSounds['gameover']:play()
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
        function()
            gSounds['gameover']:stop()
            gStateStack:pop()
            gStateStack:push(StartState())
            gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
        end))
    end
end

function GameOverState:render()
    local shadow = 1
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0 + shadow, VIRTUAL_HEIGHT / 2 - 32 + shadow, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
end
