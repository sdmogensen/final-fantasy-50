Chest = Class{}

function Chest:init(mapX, mapY, itemName, itemList)
    self.mapX = mapX
    self.mapY = mapY
    self.itemName = itemName
    self.items = itemList
    self.opened = false
end

function Chest:open()
    -- if the chest has not been opened, add the item to the inventory and display a message
    if not self.opened then
        self.opened = true
        gSounds['powerup']:play()
        local item = Item(self.itemName)
        gStateStack:push(BattleMessageState('Found ' .. item.article .. ' ' .. item.name .. '!'))
        table.insert(self.items, item)
    else
        gStateStack:push(BattleMessageState("It's empty."))
    end
end

function Chest:render()
    local frame
    if self.opened then
        frame = OBJECT_DEF['chest'].opened_frame
    else
        frame = OBJECT_DEF['chest'].unopened_frame
    end
    love.graphics.draw(gTextures[OBJECT_DEF['chest'].texture], gFrames[OBJECT_DEF['chest'].texture][frame], (self.mapX - 1) * TILE_SIZE, (self.mapY - 1) * TILE_SIZE)
end
