local PlayerChangedVelocity = class("PlayerChangedVelocity")

function PlayerChangedVelocity:initialize(vx, vy)
    self.vx = vx
    self.vy = vy
end

return PlayerChangedVelocity