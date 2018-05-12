Object = Class{}

function Object:init(mapX, mapY, name, text, itemName, itemList)
    self.mapX = mapX
    self.mapY = mapY
    self.name = name
    self.text = text
    self.itemName = itemName
    self.itemList = itemList
    self.interacted = false
end

function Object:onInteract()
    if self.itemName and not self.interacted then
        self.interacted = true
        local item = Item(self.itemName)
        gStateStack:push(BattleMessageState('You found ' .. item.article .. ' ' .. item.name .. '!'))
        gSounds['powerup']:play()
        table.insert(self.itemList, item)
    else
        gStateStack:push(BattleMessageState(self.text))
    end
end

function Object:render()
    love.graphics.draw(gTextures[OBJECT_DEF[self.name].texture], gFrames[OBJECT_DEF[self.name].texture][OBJECT_DEF[self.name].frame], (self.mapX - 1) * TILE_SIZE, (self.mapY - 1) * TILE_SIZE)
end
