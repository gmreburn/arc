local PositionComponent = require('components/Position')
local VelocityComponent = require('components/Velocity')
local TeamComponent = require('components/Team')
local ZIndexComponent = require('components/ZIndex')

WeaponEntity = class("WeaponEntity", Entity)

function WeaponEntity:initialize(x, y, angle, team)
    Entity.initialize(self)
    self:add(PositionComponent(x, y))
    self:add(TeamComponent(team))
    self:add(ZIndexComponent(2))
end

return WeaponEntity