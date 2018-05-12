Map = Class{}

function Map:init(map)
    local map_def
    -- load proper map_def
    if map == 'overworld' then
        map_def = OVERWORLD_DEF
    elseif map == 'town' then
        map_def = TOWN_DEF
    elseif map == 'cave' then
        map_def = CAVE_DEF
    elseif map == 'dungeon' then
        map_def = DUNGEON_LV1_DEF
    elseif map == 'dungeon-lv2' then
        map_def = DUNGEON_LV2_DEF
    elseif map == 'dungeon-lv3' then
        map_def = DUNGEON_LV3_DEF
    end
    assert(map_def) -- map_def must exist

    self.height = map_def['height']
    self.width = map_def['width']

    -- separate the collision layer from the display layers
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
