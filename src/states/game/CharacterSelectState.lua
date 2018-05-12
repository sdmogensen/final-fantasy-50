CharacterSelectState = Class{__includes = BaseState}

function CharacterSelectState:init()
    self.spriteWidth = PLAYER_DEFS['width']
    -- sprite ids of the 4 players
    self.sprite_ids = {1,1,1,1}
    -- location of the 4 sprites (3 of them start off offscreen)
    self.spriteX = {VIRTUAL_WIDTH/2 - self.spriteWidth/2, VIRTUAL_WIDTH, VIRTUAL_WIDTH, VIRTUAL_WIDTH}
    self.spriteY = {VIRTUAL_HEIGHT/2 - 40, VIRTUAL_HEIGHT, VIRTUAL_HEIGHT, VIRTUAL_HEIGHT}
    -- index of current sprite
    self.current_sprite = 1
    self.canInput = true
end

function CharacterSelectState:update(dt)
    if not self.canInput then return end

    if love.keyboard.wasPressed('right') then
        self.canInput = false
        -- shift current sprite offscreen to the right
        Timer.tween(0.2, {
            [self.spriteX] = {[self.current_sprite] = VIRTUAL_WIDTH}
        }):finish(function()
            -- rotate number designation in sprite_ids
            self.sprite_ids[self.current_sprite] = self.sprite_ids[self.current_sprite] - 1
            if self.sprite_ids[self.current_sprite] == 0 then self.sprite_ids[self.current_sprite] = #PLAYER_IDS end
            -- shift incoming sprite from the left to the right
            self.spriteX[self.current_sprite] = -self.spriteWidth
            Timer.tween(0.2, {
                [self.spriteX] = {[self.current_sprite] = VIRTUAL_WIDTH/2 - self.spriteWidth/2}
            }):finish(function()
                self.canInput = true
            end)
        end)
    end
    if love.keyboard.wasPressed('left') then
        self.canInput = false
        -- shift current sprite offscreen to the left
        Timer.tween(0.2, {
            [self.spriteX] = {[self.current_sprite] = -self.spriteWidth}
        }):finish(function()
            -- rotate number designation in sprite_ids
            self.sprite_ids[self.current_sprite] = self.sprite_ids[self.current_sprite] % #PLAYER_IDS + 1
            -- shift incoming sprite from the right to the left
            self.spriteX[self.current_sprite] = VIRTUAL_WIDTH
            Timer.tween(0.2, {
                [self.spriteX] = {[self.current_sprite] = VIRTUAL_WIDTH/2 - self.spriteWidth/2}
            }):finish(function()
                self.canInput = true
            end)
        end)
    end
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- if this was the last sprite to select, initialize the players and switch to overworld state
        if self.current_sprite == 4 then
        local players = {}
        for k, sprite_id in pairs(self.sprite_ids) do
            table.insert(players, Player {
                player_id = PLAYER_IDS[sprite_id],
                player_num = k
            })
        end
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
        function()
            -- remove character select state
            gStateStack:pop()
            gSounds['intro-theme']:stop()
            gSounds['town-theme']:setLooping(true)
            gSounds['town-theme']:play()
            local items = {}
            gStateStack:push(OverworldState(players, items, 'town', Location_defs(players, items), {x = 7, y = 9}))
            gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
        end))
        else
            -- shift the current sprite to the bottom and bring the next sprite into the center
            self.spriteY[self.current_sprite] = VIRTUAL_HEIGHT * 3 / 4
            self.spriteX[self.current_sprite] = VIRTUAL_WIDTH * self.current_sprite / 4 - self.spriteWidth / 2
            self.sprite_ids[self.current_sprite + 1] = self.sprite_ids[self.current_sprite]
            self.current_sprite = self.current_sprite + 1
            self.spriteY[self.current_sprite] = VIRTUAL_HEIGHT / 2 - 40
            self.spriteX[self.current_sprite] = VIRTUAL_WIDTH / 2 - self.spriteWidth / 2
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
        if self.current_sprite == i then
            -- render the role's description
            love.graphics.printf(PLAYER_DEFS[sprite_name].description, 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')
        end
        -- render the sprite and role name
        love.graphics.draw(gTextures[sprite_name], gFrames[PLAYER_IDS[self.sprite_ids[i]]][PLAYER_ANIMATIONS['idle-down'].frames[1]], self.spriteX[i], self.spriteY[i])
        love.graphics.printf(PLAYER_DEFS[sprite_name].type, self.spriteX[i] - VIRTUAL_WIDTH/2 + self.spriteWidth/2 + 1, self.spriteY[i] + PLAYER_DEFS['height'], VIRTUAL_WIDTH, 'center')
    end
end
