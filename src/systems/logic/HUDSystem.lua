local lg = love.graphics
local HeroEntityChanged = require('events/HeroEntityChanged')
local FrameEntity = require('entities/HUD/Frame')
local FrameCapEntity = require('entities/HUD/FrameCap')
local FramePostEntity = require('entities/HUD/FramePost')
local HealthEntity = require('entities/HUD/Health')

local HeadsUpDisplaySystem = class("HeadsUpDisplaySystem", System)

local hero = nil

function HeadsUpDisplaySystem:initialize(eventManager)
    System.initialize(self)

    eventManager:addListener("HeroEntityChanged", self, self.onHeroEntityChanged)

    stack:current().engine:addEntity(FrameEntity())
    stack:current().engine:addEntity(FrameCapEntity())
    for i = 1, math.ceil((lg.getHeight()-496) / 16) do
        stack:current().engine:addEntity(FramePostEntity(i))
    end
    stack:current().engine:addEntity(HealthEntity())
end

function HeadsUpDisplaySystem:onHeroEntityChanged(event)
    hero = event.hero
end

function HeadsUpDisplaySystem:requires()
    return {"health", "energy", "inventory"}
end

function HeadsUpDisplaySystem:update()

end

return HeadsUpDisplaySystem