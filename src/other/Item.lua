Item = Class{}

function Item:init(name)
    self.name = ITEM_DEFS[name].name
    self.article = ITEM_DEFS[name].article
    self.onConsume = ITEM_DEFS[name].onConsume
end

function Item:consume(player)
    self.onConsume(player)
end
