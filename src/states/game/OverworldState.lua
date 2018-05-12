--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

OverworldState = Class{__includes = BaseState}

function OverworldState:init(players, items, area, location_defs, position)
    self.players = players
    self.visible_player = self.players[1]
    self.visible_player:setMapPosition(position.x, position.y)

    self.items = items
    self.area = area
    self.location_defs = location_defs
    self.map = Map(self.area)
    self.camera = Camera()
    self.NPCs = self.location_defs[self.area].NPCs
    self.chests = self.location_defs[self.area].chests
    self.objects = self.location_defs[self.area].objects

    self.visible_player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.visible_player, self) end,
        ['idle'] = function() return PlayerIdleState(self.visible_player, self) end
    }
    self.visible_player.stateMachine:change('idle')

    for k, NPC in pairs(self.NPCs) do
        NPC.stateMachine = StateMachine {
            ['idle'] = function() return EntityIdleState(NPC) end
        }
        NPC.stateMachine:change('idle')
    end

    self:updateCamera()

    if self.area == 'dungeon-lv3' then
        self.dragon = Dragon(6,4)
    end
end

function OverworldState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camera:update(math.max(TILE_SIZE, math.min(TILE_SIZE * (self.map.width - 1) - VIRTUAL_WIDTH, self.visible_player.x - (VIRTUAL_WIDTH / 2 - 8))),
                       math.max(TILE_SIZE, math.min(TILE_SIZE * (self.map.height - 1) - VIRTUAL_HEIGHT, self.visible_player.y - (VIRTUAL_HEIGHT / 2 - 16))))
end

function OverworldState:checkForLocationChange(mapX, mapY)
    if self.area == 'town' then
        if mapY == self.map.height then
            self:loadNewLocation('overworld', 42, 7)
            return true
        elseif mapX == 38 and mapY == 23 then
            self:loadNewLocation('cave', 13, 13)
            return true
        end
    elseif self.area == 'cave' then
        if mapX == 13 and mapY == 14 then
            self:loadNewLocation('town', 38, 24)
            return true
        end
    elseif self.area == 'overworld' then
        if mapX == 42 and mapY == 6 then
            self:loadNewLocation('town', 16, 29)
            return true
        elseif mapX == 5 and mapY == 6 then
            self:loadNewLocation('dungeon', 8, 26)
            return true
        end
    elseif self.area == 'dungeon' then
        if mapX == 8 and mapY == 27 then
            self:loadNewLocation('overworld', 5, 7)
            return true
        elseif mapX == 37 and mapY == 20 then
            self:loadNewLocation('dungeon-lv2', 4, 22)
            return true
        end
    elseif self.area == 'dungeon-lv2' then
        if mapX == 3 and mapY == 22 then
            self:loadNewLocation('dungeon', 36, 20)
            return true
        elseif mapX == 8 and mapY == 5 then
            self:loadNewLocation('dungeon-lv3', 8, 24)
            return true
        end
    elseif self.area == 'dungeon-lv3' then
        if mapX == 8 and mapY == 25 then
            self:loadNewLocation('dungeon-lv2', 8, 6)
            return true
        end
    end
    return false
end

function OverworldState:loadNewLocation(area, mapX, mapY)
    gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 0, to = 255 }, FADE_SPEED,
    function()
        if gSounds[self.area .. '-theme'] and gSounds[area .. '-theme'] then
            gSounds[self.area .. '-theme']:stop()
            gSounds[area .. '-theme']:setLooping(true)
            gSounds[area .. '-theme']:play()
        end
        gStateStack:pop()
        gStateStack:push(OverworldState(self.players, self.items, area, self.location_defs, {x = mapX, y = mapY}))
        gStateStack:push(FadeState({ r = 255, g = 255, b = 255 }, { from = 255, to = 0 }, FADE_SPEED))
    end))
end

function OverworldState:update(dt)
    self.visible_player:update(dt)
    self:updateCamera()
end

function OverworldState:render()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camera.x), -math.floor(self.camera.y))
    self.map:render()
    for k, chest in pairs(self.chests) do
        chest:render()
    end
    for k, object in pairs(self.objects) do
        object:render()
    end
    for k, NPC in pairs(self.NPCs) do
        NPC:render()
    end
    if self.dragon then self.dragon:render() end
    self.visible_player:render()
    love.graphics.pop()
end
