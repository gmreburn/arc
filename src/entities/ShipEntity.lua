local hc = require('lib/HC')

local BodyComponent = require('components/physic/Body')
local EnergyComponent = require('components/logic/Energy')
local HealthComponent = require('components/logic/Health')
local PositionComponent = require('components/physic/Position')
-- local TeamComponent = require('components/logic/Team')
local SpriteComponent = require('components/graphic/Sprite')
local VelocityComponent = require('components/physic/Velocity')
local ZIndexComponent = require('components/logic/ZIndex')
local MetaComponent = require('components/logic/Meta')

local Bouncy = require('entities/weapons/Bouncy')
local Laser = require('entities/weapons/Laser')
local Missile = require('entities/weapons/Missile')
local Mortar = require('entities/weapons/Mortar')

ShipEntity = class("ShipEntity", Entity)

function ShipEntity:initialize(id, x, y, team)
    Entity.initialize(self)
    self:add(MetaComponent(id, team))
    self:add(BodyComponent(hc.circle(x, y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, ShipEntity.onCollisionWith))
    self:add(EnergyComponent())
    self:add(HealthComponent())
    self:add(PositionComponent(x, y))
    -- self:add(TeamComponent(team))
    self:add(SpriteComponent(resources.images.tuna, SHIP_SIZE * HEADING_NONE, 292 + SHIP_SIZE * team, SHIP_SIZE, SHIP_SIZE))
    self:add(VelocityComponent())
    self:add(ZIndexComponent(3))
end

function ShipEntity:onCollisionWith(entity, delta)
    -- handle collisions with other entities
end

function ShipEntity:move(x_input, y_input)
    self:get('velocity').vx = x_input * SHIP_VELOCITY
    self:get('velocity').vy = y_input * SHIP_VELOCITY

    local heading = HEADING_NONE
    if(y_input<0) then
        if(x_input == 0) then
            heading = HEADING_NORTH
        elseif (x_input < 0)  then
            heading = HEADING_NORTHWEST
        else
            heading = HEADING_NORTHEAST
        end
    elseif(y_input>0) then
        if(x_input == 0) then
            heading = HEADING_SOUTH
        elseif (x_input < 0) then
            heading = HEADING_SOUTHWEST
        else
            heading = HEADING_SOUTHEAST
        end
    elseif(x_input>0) then
        heading = HEADING_EAST
    elseif(x_input<0) then
        heading = HEADING_WEST
    end

    self:get('sprite').quad:setViewport(SHIP_SIZE*(heading-1), 292+SHIP_SIZE*(self:get('team').value), SHIP_SIZE, SHIP_SIZE)
end

function ShipEntity:firePrimaryWeapon(x, y)
    if(self:get('energy').remaining > 1) then
        local position = self:get('position')
        
        self:get('energy').remaining = self:get('energy').remaining - 1
        engine:addEntity(Laser(position.x, position.y, math.atan2(position.x - x, position.y - y)))
    end
end

function ShipEntity:fireSecondaryWeapon(x, y, weapon)
    if(self:get('energy').remaining > 2) then
        local position = self:get('position')
        if(weapon == WEAPON_MISSILE) then
            engine:addEntity(Missile(position.x, position.y, math.atan2(position.x - x, position.y - y)))
        elseif(weapon == WEAPON_GRENADE) then
            engine:addEntity(Mortar(x, y))
        else
            engine:addEntity(Bouncy(position.x, position.y, math.atan2(position.x - x, position.y - y)))
        end
    end
end

function ShipEntity:selectWeapon(weapon)
    if(weapon ~= self:get('meta').activeWeapon and weapon == WEAPON_MISSILE or weapon == WEAPON_MORTAR or weapon == WEAPON_GRENADE) then
        self:get('meta').activeWeapon = weapon
    end
end

return ShipEntity