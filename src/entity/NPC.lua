NPC = Class{__includes = Entity}

function NPC:init(def)
    Entity.init(self, def)

    -- texts that the NPC will speak
    self.texts = def.texts
    -- actions that will occur as a result of speaking with this NPC
    self.afterTalk = {}
    if not def.afterTalk then
        for i = 1, #self.texts do
            table.insert(self.afterTalk, function() end)
        end
    else
        self.afterTalk = def.afterTalk
    end

    self.timesTalkedTo = 0

    self.width = NPC_DEFS[def.NPC_id]['width']
    self.height = NPC_DEFS[def.NPC_id]['height']
    self.scale = NPC_DEFS[def.NPC_id]['scale']
    self.offset = NPC_DEFS[def.NPC_id]['offset']
    self.animations = self:createAnimations(NPC_DEFS[def.NPC_id]['animations'], NPC_DEFS[def.NPC_id]['texture'])
end

function NPC:onInteract(direction)
    self.timesTalkedTo = math.min(self.timesTalkedTo + 1, #self.texts)

    -- rotate the NPC to face the player
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

    -- push the dialogue state and afterwards do the associated action
    gStateStack:push(DialogueState(self.texts[self.timesTalkedTo], self.afterTalk[self.timesTalkedTo]))
end
