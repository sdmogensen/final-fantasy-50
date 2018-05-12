DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, callback)
    self.textbox = Textbox(6, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH - 12, 58, text, 3)
    self.callback = callback or function() end
end

function DialogueState:update(dt)
    self.textbox:update(dt)

    if self.textbox:isClosed() then
        gStateStack:pop()
        self.callback()
    end
end

function DialogueState:render()
    self.textbox:render()
end
