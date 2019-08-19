local VelocityChanged = class("VelocityChanged")

function VelocityChanged:initialize(playerid, vx, vy)
    self.playerid = playerid
    self.vx = vx
    self.vy = vy
end

return VelocityChanged