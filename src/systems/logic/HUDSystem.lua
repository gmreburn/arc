
local HeroEntityChanged = require('events/HeroEntityChanged')

local HeadsUpDisplaySystem = class("HeadsUpDisplaySystem", System)

function HeadsUpDisplaySystem:initialize(eventManager)
    System.initialize(self)

    eventManager:addListener("HeroEntityChanged", self, self.onHeroEntityChanged)
end

function HeadsUpDisplaySystem:onHeroEntityChanged(event)
end

function HeadsUpDisplaySystem:requires()
    return {"health", "energy", "inventory"}
end

return HeadsUpDisplaySystem

