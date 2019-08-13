local FarplaneSystem = class("FarplaneSystem", System)

function FarplaneSystem:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(resources.images.farplane, 0, 0, 0, 1, 1)
end

return FarplaneSystem
