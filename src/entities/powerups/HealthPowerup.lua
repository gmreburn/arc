local PowerupEntity = require('entities/powerups/Powerup')

HealthPowerupEntity = class("HealthPowerupEntity", PowerupEntity)

function HealthPowerupEntity:initialize(x, y)
    PowerupEntity.initialize(self, x, y, HealthPowerupEntity.onCollisionWith)
end

function HealthPowerupEntity:onCollisionWith(entity)
    entity:get('health').remaining = math.min(MAX_HEALTH, entity:get('health').remaining + 2)
    
    return true
end

return HealthPowerupEntity