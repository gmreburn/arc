local Farplane = class('Farplane')

function Farplane:draw()    
    love.graphics.draw(resources.images.farplane, love.graphics.getWidth()-resources.images.farplane:getWidth(), love.graphics.getHeight()-resources.images.farplane:getHeight(), 0, 1, 1)
end

return Farplane