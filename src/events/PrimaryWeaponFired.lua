local PrimaryWeaponFired = class("PrimaryWeaponFired")

function PrimaryWeaponFired:initialize(playerid, x, y, theta)
    self.playerid = playerid
    self.x = x
    self.y = y
    self.theta = theta
end

return PrimaryWeaponFired