local Sprite = class("Sprite")

function Sprite:initialize(resource, quad)
    self.resource = resource
    self.quad = quad
end

return Sprite