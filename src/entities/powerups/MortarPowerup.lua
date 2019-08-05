local PowerupEntity = require('entities/powerups/Powerup')

MortarPowerupEntity = class("MortarPowerupEntity", PowerupEntity)

function MortarPowerupEntity:initialize(x, y)
    PowerupEntity.initialize(self, x, y, MortarPowerupEntity.onCollisionWith)
end

function MortarPowerupEntity:onCollisionWith(entity)
    entity:get('inventory').mortars = math.min(MAX_GRENADES, entity:get('inventory').mortars + 1)
    
    return true
end

return MortarPowerupEntity