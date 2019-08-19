local LaserHit = class("LaserHit")

function LaserHit:initialize(playerHit, damageGivenByPlayer)
    self.playerHit = playerHit
    self.damageGivenByPlayer = damageGivenByPlayer
end

return LaserHit