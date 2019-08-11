local MousePressed = class("MousePressed")

function MousePressed:initialize(x, y, button)
    self.x = x
    self.y = y
    self.button = button
end

return MousePressed
