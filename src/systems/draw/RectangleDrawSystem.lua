local RectangleDrawSystem = class("RectangleDrawSystem", System)

function RectangleDrawSystem:draw()
    love.graphics.setColor(255, 255, 255)
    for index, entity in ipairs(self.targets) do
        love.graphics.setColor( 67, 0, 0, 180 )
        love.graphics.rectangle("fill", love.graphics.getWidth()-106, 264, 56, 14)
        -- local position = entity:get("Position")
        -- local rectangle = entity:get("Rectangle2")

        -- love.graphics.setColor( rectangle.red, rectangle.green, rectangle.blue, rectangle.alpha )
        -- love.graphics.rectangle("fill", position.x, position.y, rectangle.width, rectangle.height)

    end
end

function RectangleDrawSystem:requires()
    return {"Position", "Rectangle2"}
end

return RectangleDrawSystem