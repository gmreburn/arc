local Transformable = require('components/physic/Transformable')
local Vector = require('helper/Vector')
local VelocityComponent = require('components/physic/Velocity')
local TeamComponent = require('components/logic/Team')
local ZIndexComponent = require('components/logic/ZIndex')

WeaponEntity = class("WeaponEntity", Entity)

function WeaponEntity:initialize(position, team)
    Entity.initialize(self)
    self:add(Transformable(position))
    self:add(TeamComponent(team))
    self:add(ZIndexComponent(2))
end

function WeaponEntity:destroy()
    stack:current().engine:removeEntity(self)
end

return WeaponEntity