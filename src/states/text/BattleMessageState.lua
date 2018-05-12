--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleMessageState = Class{__includes = BaseState}

function BattleMessageState:init(msg, onClose, secondsToDisplay)
    self.textbox = Textbox(0, 0, VIRTUAL_WIDTH, 22, msg, 1)

    -- function to be called once this message is popped
    self.onClose = onClose or function() end

    -- if this parameter is provided, automatically close the message
    -- after given num seconds and do not let the user close it with input
    self.secondsToDisplay = secondsToDisplay
end

function BattleMessageState:update(dt)
    if self.secondsToDisplay then
        self.secondsToDisplay = self.secondsToDisplay - dt
        if self.secondsToDisplay <= 0 then
            gStateStack:pop()
            self.onClose()
        end
    else
        self.textbox:update(dt)
        if self.textbox:isClosed() then
            gSounds['blip']:stop()
            gSounds['blip']:play()
            gStateStack:pop()
            self.onClose()
        end
    end
end

function BattleMessageState:render()
    self.textbox:render()
end
