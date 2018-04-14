--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

NPC = Class{__includes = Entity}

function NPC:init(def)
    Entity.init(self, def)

    -- text that will be
    self.text = "Hi, I'm an NPC, demonstrating some dialogue! Isn't that cool??"
end

--[[
    Function that will get called when we try to interact with this entity.
]]
function NPC:onInteract(direction)
    if direction == 'up' then
        self.direction = 'down'
    elseif direction == 'down' then
        self.direction = 'up'
    elseif direction == 'left' then
        self.direction = 'right'
    else
        self.direction = 'left'
    end
    self:changeAnimation('idle-' .. self.direction)
    gStateStack:push(DialogueState(self.text))
end
