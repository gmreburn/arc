local PowerupEntity = require('entities/powerups/Powerup')

BouncyPowerupEntity = class("BouncyPowerupEntity", PowerupEntity)

function BouncyPowerupEntity:initialize(x, y)
    PowerupEntity.initialize(self, x,y, BouncyPowerupEntity.onCollisionWith)
end

function BouncyPowerupEntity:onCollisionWith(entity)
    entity:get('inventory').bouncies = math.min(MAX_BOUNCIES, entity:get('inventory').bouncies + 1)
    
    return true
end

return BouncyPowerupEntity