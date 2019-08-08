local BouncyWeaponFired = class("BouncyWeaponFired")

function BouncyWeaponFired:initialize(playerid, x, y, theta)
    self.playerid = playerid
    self.x = x
    self.y = y
    self.theta = theta
end

return BouncyWeaponFired