local HeroFiredWeapon = class("HeroFiredWeapon")

function HeroFiredWeapon:initialize(weapon, x, y)
    self.weapon = weapon
    self.x = x
    self.y = y
end

return HeroFiredWeapon