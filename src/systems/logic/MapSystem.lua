local MapSystem = class("MapSystem", System)
local bit = require('bit')


local function is_animation(tileData)
    return bit.band(love.data.unpack("<B", tileData), 1) == 1
end
local function is_wall(tileNumber)
    return false
end

-- function HeadsUpDisplaySystem:initialize(eventManager)
function MapSystem:loadMap(mapFile, hash)
    if(love.filesystem.exists('maps/' .. mapFile .. '.map') == false) then -- todo: use love.filesystem.getInfo
        -- todo: download the map from server
        love.event.quit()
    end

    local data, err = love.filesystem.newFileData('maps/' .. mapFile .. '.map')
    if(err) then
        print(err)
    end

    if (hash ~= nil and hash ~= love.data.encode("string", "hex", love.data.hash("md5", data))) then
        -- todo: download the map from server
        print(love.data.encode("string", "hex", love.data.hash("md5", data)))
        love.event.quit()
    end

    -- read header
    self.formatId = love.data.unpack("<H", data)
    self.headerSize = love.data.unpack("<H", data, 3)
    self.version = love.data.unpack("<B", data, 5)
    self.width = love.data.unpack("<H", data, 6)
    self.height = love.data.unpack("<H", data, 8)
    self.maxPlayers = love.data.unpack("<B", data, 10)
    self.holdingTime = love.data.unpack("<B", data, 11)
    self.numTeams = love.data.unpack("<B", data, 12)
    self.gameObjective = love.data.unpack("<B", data, 13)
    self.laserDamage = love.data.unpack("<B", data, 14)
    self.specialDamage = love.data.unpack("<B", data, 15)
    self.recharge = love.data.unpack("<B", data, 16)
    self.missilesEnabled = love.data.unpack("<B", data, 17)
    self.mortarsEnabled = love.data.unpack("<B", data, 18)
    self.bounciesEnabled = love.data.unpack("<B", data, 19)
    self.powerUpPosCount = love.data.unpack("<H", data, 19)

    -- need to adjust offsets here, data loaded here is junk b/c offsets are wrong
    self.simulPowerups = love.data.unpack("<B", data, 19)
    self.switchCount = love.data.unpack("<B", data, 19)
    self.flagCounts = love.data.unpack("<I1", data, 19) -- Number of flags per team
    self.flagPoleCounts = love.data.unpack("<I1", data, 19) -- Number of poles per team
    self.flagPoleBases = love.data.unpack("<I1", data, 19) -- Flag type accepted at each flag pole 
    self.nameLen = love.data.unpack("<I1", data, 19)
    self.name = love.data.unpack("<I1", data, 19)
    self.descriptionLen = love.data.unpack("<I1", data, 19)
    self.description = love.data.unpack("<I1", data, 19)
    self.neutralCount = love.data.unpack("<I1", data, 19)
    
    local mapData = nil

    -- read tiles
    if(self.version == 2) then
        mapData = love.data.newByteData(data, self.headerSize+2)
        mapData = love.data.newByteData(data, self.headerSize+2)
    elseif(self.version == 3) then
        mapData = love.data.decompress("data", "zlib", love.data.newByteData(data, self.headerSize+2))
    end
    data = nil
    
    self.tiles = {}
    local pointer = 0
    
    for h=1,self.height do 
        self.tiles[h] = {}
        for w=1,self.width do 
            local tile = nil
            local tileData = love.data.newByteData(mapData, pointer, 2)

            if(is_animation(tileData)) then
                tile = love.data.unpack("<I1", tileData)
                animationOffset = love.data.unpack("<xI1", tileData)
            else
                tile = love.data.unpack("<I2", tileData)
            end
            self.tiles[h][w] = tile
            pointer = pointer + 2
        end
    end
end

function MapSystem:draw()

end

-- function MapSystem:requires()
--     return {"Drawable", "Transformable"}
-- end

return MapSystem