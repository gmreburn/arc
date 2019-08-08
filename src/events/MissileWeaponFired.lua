local MissileWeaponFired = class("MissileWeaponFired")

function MissileWeaponFired:initialize(playerid, x, y, theta)
    self.playerid = playerid
    self.x = x
    self.y = y
    self.theta = theta
end

return MissileWeaponFired