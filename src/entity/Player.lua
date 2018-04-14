--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    self.party_ids = def.party_ids
    self.sprite_id = self.party_ids[1]
    Entity.init(self, def)
end
