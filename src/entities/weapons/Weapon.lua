local PositionComponent = require('components/physic/Position')
local VelocityComponent = require('components/physic/Velocity')
local TeamComponent = require('components/logic/Team')
local ZIndexComponent = require('components/logic/ZIndex')

WeaponEntity = class("WeaponEntity", Entity)

function WeaponEntity:initialize(x, y, angle, team)
    Entity.initialize(self)
    self:add(PositionComponent(x, y))
    self:add(TeamComponent(team))
    self:add(ZIndexComponent(2))
end

return WeaponEntity