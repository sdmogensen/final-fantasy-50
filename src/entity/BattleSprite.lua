BattleSprite = Class{}

function BattleSprite:init(texture, frame, x, y, scale, offset)
    self.texture = texture
    self.frame = frame
    self.x = x
    self.y = y
    self.scale = scale or 1
    self.offset = offset or 0
    self.opacity = 255
    self.blinking = false

    -- https://love2d.org/forums/viewtopic.php?t=79617
    -- white shader that will turn a sprite completely white when used; allows us
    -- to brightly blink the sprite when it's acting
    self.whiteShader = love.graphics.newShader[[
        extern float WhiteFactor;

        vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
        {
            vec4 outputcolor = Texel(tex, texcoord) * vcolor;
            outputcolor.rgb += vec3(WhiteFactor);
            return outputcolor;
        }
    ]]
end

function BattleSprite:update(dt)
end

function BattleSprite:move(distance, doAfter)
    Timer.tween(0.2, {
        [self] = {x = self.x + distance}
    })
    :finish(function()
        doAfter()
    end)
end

function BattleSprite:blinkWhite(num, doAfter)
    Timer.every(0.1, function()
        self.blinking = not self.blinking
    end)
    :limit(num)
    :finish(function()
        doAfter()
    end)
end

function BattleSprite:blinkTransparent(num, doAfter)
    -- local doAfter = doAfter or function () end
    Timer.every(0.1, function()
        self.opacity = self.opacity == 64 and 255 or 64
    end)
    :limit(num)
    :finish(function()
        doAfter()
    end)
end

function BattleSprite:fadeOut(doAfter)
    Timer.tween(1.6, {
        [self] = {opacity = 0}
    })
    :finish(function()
        doAfter()
    end)
end

function BattleSprite:render()
    love.graphics.setColor(255, 255, 255, self.opacity)

    -- if blinking is set to true, we'll send 1 to the white shader, which will
    -- convert every pixel of the sprite to pure white
    love.graphics.setShader(self.whiteShader)
    self.whiteShader:send('WhiteFactor', self.blinking and 1 or 0)

    if self.frame then
        love.graphics.draw(self.texture, self.frame, self.x + self.offset, self.y, 0, self.scale)
    else
        love.graphics.draw(self.texture, self.x + self.offset, self.y, 0, self.scale)
    end
    -- reset shader
    love.graphics.setShader()
end
