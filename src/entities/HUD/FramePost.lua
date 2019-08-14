local Position = require('components/physic/Position')
local Sprite = require('components/graphic/Sprite')
local ZIndex = require('components/logic/ZIndex')

Frame = class("Frame", Entity)

function Frame:initialize(i)
    Entity.initialize(self)

    self:add(Position(love.graphics.getWidth() - 180, 480 + 16 * i))
    self:add(Sprite(resources.images.tuna, love.graphics.newQuad(460, 909, 180, 16, resources.images.tuna:getDimensions())))
    self:add(ZIndex(4))
end

return Frame