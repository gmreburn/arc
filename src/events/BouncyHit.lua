local BouncyHit = class("BouncyHit")

function BouncyHit:initialize(playerHit, damageGivenByPlayer)
    self.playerHit = playerHit
    self.damageGivenByPlayer = damageGivenByPlayer
end

return BouncyHit