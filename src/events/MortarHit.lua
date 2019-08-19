local MortarHit = class("MortarHit")

function MortarHit:initialize(playerHit, damageGivenByPlayer)
    self.playerHit = playerHit
    self.damageGivenByPlayer = damageGivenByPlayer
end

return MortarHit