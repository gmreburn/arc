require 'helper.tables'

local DrawSystem = class("DrawSystem", System)

function DrawSystem:initialize()
    System.initialize(self)
    self.sortedTargets = {}
end

function DrawSystem:draw()
    love.graphics.setColor(255, 255, 255)
    for index, entity in ipairs(self.sortedTargets) do
        local sprite = entity:get("Sprite")
        local position = entity:get("Position")

        love.graphics.draw(sprite.resource, sprite.quad, position.x, position.y)
    end
end

function DrawSystem:requires()
    return {"Sprite", "Position", "ZIndex"}
end

function DrawSystem:addEntity(entity)
    -- Entitys are sorted by Index, therefore we had to overwrite System:addEntity
    System.addEntity(self, entity)
    self.sortedTargets = table.resetIndice(self.targets)
    table.sort(self.sortedTargets, function(a, b) return a:get("ZIndex").index < b:get("ZIndex").index end)
end

function DrawSystem:removeEntity(entity)
    -- Entitys are sorted by Index, therefore we had to overwrite System:addEntity
    System.removeEntity(self, entity)
    self.sortedTargets = table.resetIndice(self.targets)
    table.sort(self.sortedTargets, function(a, b) return a:get("ZIndex").index < b:get("ZIndex").index end)
end

return DrawSystem
