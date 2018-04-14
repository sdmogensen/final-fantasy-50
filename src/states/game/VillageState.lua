--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

VillageState = Class{__includes = BaseState}

function VillageState:init(sprite_ids)
    self.map = Map('village')
    self.camX = 0
    self.camY = 0

    local visible_player_id = PLAYER_IDS[sprite_ids[1]]
    self.player = Player {
        mapX = 10,
        mapY = 10,
        scale = 0.5,
        width = PLAYER_DEFS['width'],
        height = PLAYER_DEFS['height'],
        offset = PLAYER_DEFS[visible_player_id]['offset'],
        animations = PLAYER_ANIMATIONS,
        texture = visible_player_id,
        party_ids = sprite_ids
    }
    self.NPCs = {
      NPC {
        mapX = 12,
        mapY = 11,
        scale = 0.5,
        width = NPC_DEFS['man']['width'],
        height = NPC_DEFS['man']['height'],
        offset = NPC_DEFS['man']['offset'],
        animations = NPC_DEFS['man']['animations'],
        texture = NPC_DEFS['man']['texture']
      },
      NPC {
        mapX = 14,
        mapY = 6,
        scale = 0.5,
        NPC_defs = NPC_DEFS['woman'],
        width = NPC_DEFS['woman']['width'],
        height = NPC_DEFS['woman']['height'],
        offset = NPC_DEFS['woman']['offset'],
        animations = NPC_DEFS['woman']['animations'],
        texture = NPC_DEFS['woman']['texture']
      }
    }

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.map, self.NPCs) end,
        ['idle'] = function() return PlayerIdleState(self.player, self.NPCs) end
    }
    self.player.stateMachine:change('idle')

    for k, NPC in pairs(self.NPCs) do
        NPC.stateMachine = StateMachine {
            ['walk'] = function() return PlayerWalkState(NPC, self.map) end,
            ['idle'] = function() return PlayerIdleState(NPC) end
        }
        NPC.stateMachine:change('idle')
    end
    
    self:updateCamera()
end

function VillageState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.map.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))
    self.camY = math.max(0,
        math.min(TILE_SIZE * self.map.height - VIRTUAL_HEIGHT,
        self.player.y - (VIRTUAL_HEIGHT / 2 - 16)))
end

function VillageState:update(dt)
    self.player:update(dt)
    self:updateCamera()
end

function VillageState:render()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    self.map:render()
    for k, NPC in pairs(self.NPCs) do
        NPC:render()
    end
    self.player:render()
end
