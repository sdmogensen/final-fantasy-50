--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

TileMap = Class{}

function TileMap:init(layer)
    self.tiles = layer['data']
    self.width = layer['width']
    self.height = layer['height']
    self.name = layer['name']
end

function TileMap:render()
    if self.name == COLLISION_LAYER then return end
    for y = 1, self.height do
        for x = 1, self.width do
            local tile_id = self.tiles[x + self.width * (y - 1)]
            if tile_id > 0 then
              love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile_id],
                  (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    end
end
