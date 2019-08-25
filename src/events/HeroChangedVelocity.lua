local HeroChangedVelocity = class("HeroChangedVelocity")

function HeroChangedVelocity:initialize(vx, vy)
    self.vx = vx
    self.vy = vy
end

return HeroChangedVelocity