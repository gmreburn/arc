local Sprite = class("sprite")
local lg = love.graphics

function Sprite:initialize(resource, x, y, size)
    self.resource = resource

    if(type(x) == "number") then
        self.quad =  lg.newQuad(x, y, size, size, resource:getDimensions())
    else
        self.quad = x
    end
end

return Sprite