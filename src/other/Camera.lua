Camera = Class{}

function Camera:init()
    self.x = 0
    self.y = 0
end

function Camera:update(x, y)
    self.x = x
    self.y = y
end
