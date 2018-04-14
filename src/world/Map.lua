--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Map = Class{}

function Map:init(map)
    local map_def
    if map == 'overworld' then
        map_def = OVERWORLD_DEF
    elseif map == 'village' then
        map_def = VILLAGE_DEF
    end
    assert(map_def) -- map_def must exist

    self.height = map_def['height']
    self.width = map_def['width']

    self.displayLayers = {}
    for k, layer in pairs(map_def['layers']) do
        if layer['name'] == COLLISION_LAYER then
            self.collisionLayer = layer['data']
        else
            table.insert(self.displayLayers, TileMap(layer))
        end
    end
    assert(self.collisionLayer) -- must have collision layer
end

function Map:render()
    for k, layer in pairs(self.displayLayers) do
        layer:render()
    end
end
