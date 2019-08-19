local MissileHit = class("MissileHit")

function MissileHit:initialize(playerHit, damageGivenByPlayer)
    self.playerHit = playerHit
    self.damageGivenByPlayer = damageGivenByPlayer
end

return MissileHit