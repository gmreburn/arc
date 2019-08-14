local Position = require('components/physic/Position')
local Rectangle = require('components/graphic/Rectangle')

Health = class("Health", Entity)

function Health:initialize()
    Entity.initialize(self)

    self:add(Position(love.graphics.getWidth() - 50 - 56, 164))
    self:add(Rectangle(56, 14, 67, 0, 0, 180))
end

return Health