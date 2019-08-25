local HeroChangedWeapon = class("HeroChangedWeapon")

function HeroChangedWeapon:initialize(weapon)
    self.weapon = weapon
end

return HeroChangedWeapon