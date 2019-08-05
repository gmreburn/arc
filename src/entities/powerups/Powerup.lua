local hc = require 'libs/HC'

local AnimationComponent = require('components/Animation')
local BodyComponent = require('components/Body')
local PositionComponent = require('components/Position')
local SpriteComponent = require('components/Sprite')
local ZIndexComponent = require('components/ZIndex')

local resources = require('core/Resources')

PowerupEntity = class("PowerupEntity", Entity)

function PowerupEntity:initialize(x, y, callback)
    Entity.initialize(self)
    self:add(AnimationComponent(1, 6, 0, 424, true))
    self:add(BodyComponent(hc.rectangle(x,y, POWERUP_SIZE, POWERUP_SIZE / 2), self, 0, callback))
    self:add(PositionComponent(x, y))
    self:add(SpriteComponent(resources.images.tuna, 0, 424, POWERUP_SIZE))
    self:add(ZIndexComponent(2))
end

return PowerupEntity