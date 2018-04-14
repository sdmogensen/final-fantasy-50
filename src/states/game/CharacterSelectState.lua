--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

CharacterSelectState = Class{__includes = BaseState}

function CharacterSelectState:init()
    self.sprite_ids = {1,1,1,1}
    self.spriteX = {VIRTUAL_WIDTH/2 - PLAYER_DEFS['width']/2, VIRTUAL_WIDTH, VIRTUAL_WIDTH, VIRTUAL_WIDTH}
    self.spriteY = {VIRTUAL_HEIGHT/2 - 40, VIRTUAL_HEIGHT, VIRTUAL_HEIGHT, VIRTUAL_HEIGHT}
    self.current_sprite = 1
end

function CharacterSelectState:update(dt)
    if love.keyboard.wasPressed('right') then
        Timer.tween(0.2, {
            [self.spriteX] = {[self.current_sprite] = VIRTUAL_WIDTH}
        }):finish(function()
            self.sprite_ids[self.current_sprite] = self.sprite_ids[self.current_sprite] - 1
            if self.sprite_ids[self.current_sprite] == 0 then self.sprite_ids[self.current_sprite] = #PLAYER_IDS end
            self.spriteX[self.current_sprite] = 0
            Timer.tween(0.2, {
                [self.spriteX] = {[self.current_sprite] = VIRTUAL_WIDTH/2 - PLAYER_DEFS['width']/2}
            })
        end)
    end
    if love.keyboard.wasPressed('left') then
        Timer.tween(0.2, {
            [self.spriteX] = {[self.current_sprite] = 0}
        }):finish(function()
            self.sprite_ids[self.current_sprite] = self.sprite_ids[self.current_sprite] % #PLAYER_IDS + 1
            self.spriteX[self.current_sprite] = VIRTUAL_WIDTH
            Timer.tween(0.2, {
                [self.spriteX] = {[self.current_sprite] = VIRTUAL_WIDTH/2 - PLAYER_DEFS['width']/2}
            })
        end)
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.current_sprite == 4 then
          gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, 1,
          function()
              gStateStack:pop()
              gStateStack:push(VillageState(self.sprite_ids))
              gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, 1,
              function() end))
          end))
        else
            self.spriteY[self.current_sprite] = VIRTUAL_HEIGHT*3/4
            self.spriteX[self.current_sprite] = VIRTUAL_WIDTH*self.current_sprite/4 - PLAYER_DEFS['width']/2
            self.sprite_ids[self.current_sprite + 1] = self.sprite_ids[self.current_sprite]
            self.current_sprite = self.current_sprite + 1
            self.spriteY[self.current_sprite] = VIRTUAL_HEIGHT/2 - 40
            self.spriteX[self.current_sprite] = VIRTUAL_WIDTH/2 - PLAYER_DEFS['width']/2
        end
    end
end

function CharacterSelectState:render()
    love.graphics.clear(0, 0, 0, 255)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Select your 4 characters:', 0, 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    for i = 1, 4 do
        local sprite_name = PLAYER_IDS[self.sprite_ids[i]]
        love.graphics.draw(gTextures[sprite_name], gFrames[PLAYER_IDS[self.sprite_ids[i]]][PLAYER_ANIMATIONS['idle-down']['frames'][1]], self.spriteX[i], self.spriteY[i])
        love.graphics.printf(PLAYER_DEFS[sprite_name]['type'], self.spriteX[i] - VIRTUAL_WIDTH/2 + PLAYER_DEFS['width']/2 + 1, self.spriteY[i] + PLAYER_DEFS['height'], VIRTUAL_WIDTH, 'center')
    end
end
