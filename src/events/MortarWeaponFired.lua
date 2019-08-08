local MortarWeaponFired = class("MortarWeaponFired")

function MortarWeaponFired:initialize(playerid, origin_x, origin_y, dest_x, dest_y)
    self.playerid = playerid
    self.origin_x = origin_x
    self.origin_y = origin_y
    self.dest_x = dest_x
    self.dest_y = dest_y
end

return MortarWeaponFired