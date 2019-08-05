local hc = require 'libs.HC'

local BodyComponent = require('components.Body')
local PositionComponent = require('components.Position')
local SpriteComponent = require('components.Sprite')
local ZIndexComponent = require('components.ZIndex')

local resources = require('core/Resources')

TileEntity = class("TileEntity", Entity)

local tileCache = {}

function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
  end
  
local isWall = Set{ 6,7,46,47,48,49 }

function TileEntity:onCollisionWith(entity, delta)
    if(delta.x > 1 or delta.x < -1) then
        entity:get('velocity').vx = 0
    end
    if(delta.y > 1 or delta.y < -1) then
        entity:get('velocity').vy=0
    end
end

function TileEntity:initialize(tile_number, x, y)
    Entity.initialize(self)

    if(tileCache[tile_number] == nil) then
        tileCache[tile_number] = love.graphics.newQuad(math.floor(tile_number%40)*TILE_SIZE, math.floor(tile_number/40)*TILE_SIZE, TILE_SIZE, TILE_SIZE, resources.images.tiles:getDimensions())
    end

    self:add(PositionComponent(x, y))
    self:add(SpriteComponent(resources.images.tiles, tileCache[tile_number]))
    self:add(ZIndexComponent(1))

    if(isWall[tile_number]) then
        self:add(BodyComponent(hc.rectangle(x,y, TILE_SIZE, TILE_SIZE), self, 0, TileEntity.onCollisionWith))
    end
end

return TileEntity