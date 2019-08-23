local hc = require('lib/HC')
local ShipEntity = require("entities/ShipEntity")
local Laser = require("entities/weapons/Laser")
local Missile = require("entities/weapons/Missile")
local Mortar = require("entities/weapons/Mortar")
local Bouncy = require("entities/weapons/Bouncy")

local State = require("core/State")
local ServerState = class("ServerState", State)

local enet = require "enet"
local host = nil
local players = {}
local next_time = nil
local worldState = {}

-- todo:
-- FLAG_CAPTURED
-- FLAG_TAKEN
-- FLAG_DROPPED
-- SWITCH_FLIPPED
-- DIED
-- DAMAGE_TAKEN

function ServerState:load(mapFile)
    min_dt = 1 / 64
    next_time = love.timer.getTime()
    local MapSystem = require("systems/logic/MapSystem")

    hc.resetHash(SHIP_SIZE*4)
    self.engine = Engine()
    self.eventmanager = EventManager()
    
    host = enet.host_create("localhost:3000")
    self.engine:addSystem(MapSystem())

    -- load map
    self.map = mapFile
    self.engine.systemRegistry["MapSystem"]:loadMap(mapFile)
end

local fireWeaponRequest = function(weapon, playerid, x, y, theta)    
    local player = players[playerid].entity

    if(player == nil) then
        -- player not found - disconnect this peer?
        return
    end

    -- check energy level
    if(player:get("energy").remaining >= LASER_ENERGY_COST) then
        local position = player:get("position")
        local startX = position.x / 2
        local startY = position.y / 2
        
        stack:current().engine:addEntity(Laser(startX, startY, theta, player:get("team").value))
    end

    -- send to all connected clients
    host:broadcast(love.data.pack("string", "<BBBBB", weapon, playerid, x, y, th))
end

function ServerState:onConnect(data, peer)
    print(peer, "connected.")
    -- todo - start timer and disconnect peer if not receive GAME_INITIALIZE within 3 seconds?
end
local weapons = {"LASER", "MISSILE", "MORTAR", "BOUNCY"}

function ServerState:onMessage(command, data, peer)
    print("Got message: ", command, peer)

    if(command == GAME_INITIALIZE) then
        -- todo: remove JSON, use binary
        local usernameLen, index = love.data.unpack("xB", data)
        local username = love.data.unpack("s"..usernameLen, data, index)

        local position = {x = 0, y = 0}
        local team = TEAM_RED
        local secret = love.math.random(0, 0xFFFFFFFF) -- 4B
        local playerid = love.data.encode("string", "hex", love.data.hash("md5", secret)) -- 32B
        
        players[playerid] = {
            username = username,
            entity = ShipEntity(playerid, position.x, position.y, tonumber(team)),
            peer_id = peer:connect_id()
        }
        
        local payloads = {
            GAME_INITIALIZE = love.data.pack("string", "<BnBBs"..string.len(self.map), GAME_INITIALIZE, secret, team, string.len(self.map), self.map),
            PLAYER_JOINED = love.data.pack("string", "<BBBs"..usernameLen, PLAYER_JOINED, team, usernameLen, username)
        }

        stack:current().engine:addEntity(players[playerid].entity)
        
        peer:send(payloads.GAME_INITIALIZE)
        host:broadcast(payloads.PLAYER_JOINED)
    elseif(weapons[command] ~= nil) then
        local playerid = love.data.encode("string", "hex", love.data.hash("md5", love.data.unpack("<n", data)))
        local x = love.data.unpack("<xn", data)
        local y = love.data.unpack("<xxn", data)
        local theta = love.data.unpack("<xxxn", data)

        fireWeaponRequest(command, playerid, x, y, theta)
    elseif(command == TEAM_CHANGED) then
        local playerid =  love.data.encode("string", "hex", love.data.hash("md5", love.data.unpack("<n", data)))
        local team = love.data.unpack("<xn", data)

        host:broadcast(love.data.pack("string", TEAM_CHANGED, playerid, team))
    elseif(command == VELOCITY_CHANGED) then
        local playerid =  love.data.encode("string", "hex", love.data.hash("md5", love.data.unpack("<B", data)))
        local velocity = players[playerid].entity:get("velocity")

        velocity.x = love.data.unpack("<xn", data)
        velocity.y = love.data.unpack("<xxn", data)

        host:broadcast(love.data.pack("string", VELOCITY_CHANGED, playerid, velocity.x, velocity.y))
    end
end

function ServerState:onDisconnect(peer)
    print(event.peer, "disconnected.")
    -- todo: find playerid
    
    for i, player in pairs(players) do
        if(players[i].peer_id == peer:connect_id()) then
            if(players[i].entity ~= nil) then
                stack:current().engine:removeEntity(players[playerid].entity)
            end

            host:broadcast(love.data.pack("string", "<BBs"..string.len(players[i].username), PLAYER_LEFT, string.len(players[i].username), players[i].username))
        end
    end
end

function ServerState:getState()
    for i, player in pairs(players) do
        local position = players[i].entity:get("position")
        local velocity = players[i].entity:get("velocity")
        local health = players[i].entity:get("health").remaining
        local energy = players[i].entity:get("energy").remaining

        
    end
end

function ServerState:update(dt)
    next_time = next_time + min_dt

    if(host ~= nil) then
        local event = host:service()
        -- todo: this logic may be defective.. we can get stuck processing events and have no time to send ticks
        -- loop while there is an event 
        while event do
            if event.type == "receive" then
                local cmd, index = love.data.unpack("<B", event.data)
                self:onMessage(cmd, love.data.newByteData(event.data, index), event.peer)
            elseif event.type == "connect" then
                self:onConnect(event.peer)
            elseif event.type == "disconnect" then
                self:onDisconnect(event.peer)
            end
            event = host:service()
        end

        local worldState = nil
        host:broadcast(love.data.pack("string", "<B", WORLD_STATE), 1, "unreliable")
    end

    -- tick rate
    local cur_time = love.timer.getTime()
    if next_time <= cur_time then
        next_time = cur_time
        return
    end

   love.timer.sleep(next_time - cur_time)
end

return ServerState