local PowerupEntity = require('entities/powerups/Powerup')

MissilePowerupEntity = class("MissilePowerupEntity", PowerupEntity)

function MissilePowerupEntity:initialize(x, y)
    PowerupEntity.initialize(self, x, y, MissilePowerupEntity.onCollisionWith)
end

function MissilePowerupEntity:onCollisionWith(entity)
    entity:get('inventory').missiles = math.min(MAX_MISSILES, entity:get('inventory').missiles + 1)
    
    return true
end

return MissilePowerupEntity