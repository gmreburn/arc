local WeaponChanged = class("WeaponChanged")

function WeaponChanged:initialize(playerid, weapon)
    self.weapon = weapon
end

return WeaponChanged