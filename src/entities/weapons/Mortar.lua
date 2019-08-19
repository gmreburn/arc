local BodyComponent = require('components/physic/body')
local VelocityComponent = require('components/physic/velocity')

local WeaponEntity = require('entities/weapons/Weapon')

local resources = require('core/Resources')

Mortar = class("Mortar", WeaponEntity)

function Mortar:initialize(start_x, start_y, end_x, end_y, angle, team)
    WeaponEntity.initialize(start_x, start_y, angle, team)

    self:add(BodyComponent(hc.circle(start_x, start_y, SHIP_SIZE / 2), self, SHIP_SIZE / 2, Mortar.onCollisionWith))
    self:add(VelocityComponent(MORTAR_VELOCITY, MORTAR_VELOCITY))

    love.audio.play(love.audio.newSource('sound/MORTLNCH.wav', 'stream'))
end

function Mortar:onCollisionWith(entity, delta)
    if(typeof(entity) == "Tile") then
        -- need to expand this into child entities and destroy the radius upon hitting a wall
    elseif(typeof(entity) == "Ship") then
        love.audio.play(love.audio.newSource('sound/MORTHIT.wav', 'stream'))
        self.eventManager:fireEvent(MortarHit(entity:getParent():getComponent("Meta").id, self:getParent():getComponent("Meta").id))
        self:destroy()
    end
end

return Mortar