local hc = require('lib/HC')
local binser = require('lib/binser')
local Vector = require('helper/Vector')

local ShipEntity = require("entities/ShipEntity")
local Laser = require("entities/weapons/Laser")
local Missile = require("entities/weapons/Missile")
local Mortar = require("entities/weapons/Mortar")
local Bouncy = require("entities/weapons/Bouncy")
local PlayerEntity = require("entities/PlayerEntity")


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

function ServerState:fireWeapon(playerid, dest_x, dest_y)
    local player = players[playerid].entity
    local entity = nil

    if(player ~= nil) then
        local energy = player.ship:get("Energy")
        local energyCost = LASER_ENERGY_COST
        
        if(weapon == WEAPON_MISSILE) then
            energyCost = MISSILE_ENERGY_COST
        elseif(weapon == WEAPON_MORTAR) then
            energyCost = MORTAR_ENERGY_COST
        elseif(weapon == WEAPON_BOUNCY) then
            energyCost = BOUNCY_ENERGY_COST
        end

        -- check energy level
        if(energy.remaining >= energyCost) then
            local position = player.ship:get("Position")
            local start_x = position.x / 2
            local start_y = position.y / 2
            local team = player.ship:get("Team").value

            if(weapon == WEAPON_MORTAR) then
                entity = WeaponEntity(playerid, team, start_x, start_y, dest_x, dest_y)
            else
                local theta = findRotation(start_x, start_y, dest_x, dest_y)
                entity = WeaponEntity(playerid, team, start_x, start_y, theta)
            end

            stack:current().engine:addEntity(entity)
            energy.remaining = energy.remaining - energyCost
        end

    end

    if(entity ~= nil) then
        -- send to all connected clients
        host:broadcast(binser.serialize(WEAPON_FIRED, weapon, playerid, x, y, th))
    end
end

function ServerState:onConnect(peer)
    print("SERVER", peer, "connected.")
    -- todo - start timer and disconnect peer if not receive GAME_INITIALIZE within 3 seconds?
end

function ServerState:InitializeGame(peer, version, username)
    print("Initializing game for "..username)

    if(version > ARC_VERSION) then
        peer:disconnect_now()
        return
    end
    local position = Vector()
    local team = TEAM_RED
    local secret = love.math.random(0, 0xFFFFFFFF) -- 4B
    local playerid = love.data.encode("string", "hex", love.data.hash("md5", secret)) -- 32B
    
    players[playerid] = {
        username = username,
        entity = PlayerEntity(playerid, position, team),
        peer_id = peer:connect_id()
    }
    
    local payloads = {
        GAME_INITIALIZE = binser.serialize(GAME_INITIALIZE, secret, team, self.map),
        PLAYER_JOINED = binser.serialize(PLAYER_JOINED, team, username)
    }

    stack:current().engine:addEntity(players[playerid].entity)
    
    peer:send(payloads.GAME_INITIALIZE)
    host:broadcast(payloads.PLAYER_JOINED)
end

function ServerState:onMessage(peer, command, secret, ...)
    print("SERVER Received command: ", command, peer)

    if(command == GAME_INITIALIZE) then
        ServerState:InitializeGame(peer, secret, ...)
    else
        local playerid = love.data.encode("string", "hex", love.data.hash("md5", secret))

        if(command == WEAPON_FIRED) then
            self:fireWeapon(playerid, ...)
        elseif(command == TEAM_CHANGED) then
            local team = ...

            if(team >= TEAM_GREEN and team <= TEAM_NEUTRAL) then
                host:broadcast(binser.serialize(TEAM_CHANGED, playerid, team))
            end
        elseif(command == VELOCITY_CHANGED) then
            local x, y = ...
            local velocity = players[playerid].entity.ship:get("Velocity")

            velocity.x = x
            velocity.y = y

            host:broadcast(binser.serialize(VELOCITY_CHANGED, playerid, velocity.x, velocity.y))
        end
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

            host:broadcast(binser.serialize(PLAYER_LEFT, string.len(players[i].username), players[i].username))
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
                local data = binser.deserialize(event.data)
                self:onMessage(event.peer, unpack(data))
            elseif event.type == "connect" then
                self:onConnect(event.peer)
            elseif event.type == "disconnect" then
                self:onDisconnect(event.peer)
            end
            event = host:service()
        end

        local worldState = nil
        host:broadcast(binser.serialize(WORLD_STATE, "TODO"), 1, "unreliable")
    end

    -- tick rate
    local cur_time = love.timer.getTime()
    if next_time <= cur_time then
        next_time = cur_time
        return
    end

   love.timer.sleep(next_time - cur_time)
end

function findRotation(x1, y1, x2, y2)
 
    local t = -math.deg(math.atan2(x2-x1,y2-y1))
    if t < 0 then t = t + 360 end;
    return t;
   
end

return ServerState