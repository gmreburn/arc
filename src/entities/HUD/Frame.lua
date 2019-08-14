local Position = require('components/physic/Position')
local Sprite = require('components/graphic/Sprite')
local ZIndex = require('components/logic/ZIndex')

Frame = class("Frame", Entity)

function Frame:initialize()
    Entity.initialize(self)

    self:add(Position(love.graphics.getWidth() - 180, 0))
    self:add(Sprite(resources.images.tuna, love.graphics.newQuad(460, 260, 180, 480, resources.images.tuna:getDimensions())))
    self:add(ZIndex(4))
end

return Frame