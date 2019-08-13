local Drawable = require('components/graphic/Drawable')
local Sprite = class("Sprite", Drawable)

function Sprite:initialize(resource, quad, index, sx, sy, ox, oy)
    Drawable.initialize(resource, index, sx, sy, ox, oy)
    self.quad = quad
end

return Sprite