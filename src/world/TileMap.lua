TileMap = Class{}

function TileMap:init(layer)
    self.tiles = layer['data']
    self.width = layer['width']
    self.height = layer['height']
end

function TileMap:render()
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
