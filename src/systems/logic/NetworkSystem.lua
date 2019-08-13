local json = require("lib/json")

local NetworkSystem = class("NetworkSystem", System)
local enet = require "enet"
local host = enet.host_create()
local playerid = nil
local server = nil
local ShipEntity = require('entities/ShipEntity')

-- events
local BouncyWeaponFired = require('events/BouncyWeaponFired')
local MissileWeaponFired = require('events/MissileWeaponFired')
local MortarWeaponFired = require('events/MortarWeaponFired')
local PrimaryWeaponFired = require('events/PrimaryWeaponFired')
local HeroEntityChanged = require('events/HeroEntityChanged')

function NetworkSystem:fireWeapon(weapon, team, x, y, theta)
    if(weapon == FIRE_MORTAR) then
        server:send(json.encode({
            t = FIRE_MORTAR, 
            tm = team,
            pid = playerid, 
            ox = event.origin_x, 
            oy = event.origin_y, 
            dx = event.dest_x, 
            dy = event.dest_y, 
            th = event.theta
        }))
    else
        server:send(json.encode({
            t = weapon, 
            tm = team,
            pid = playerid, 
            x = x, 
            y = y, 
            th = theta
        }))
    end
end

function NetworkSystem:setVelocity(vx, vy)
    server:send(json.encode({
        vx = vx,
        vy = vy, 
        pid = playerid
    }))
end

function NetworkSystem:initialize()
    System.initialize(self)
    server = host:connect("localhost:3000")
end

function NetworkSystem:update(dt)
    local event = host:service(100)
    if (event) then
        if event.type == "receive" then
            local message = json.decode(event.data)
            print("Got message: ", event.data, event.peer)
            if(message.t == GAME_INITIALIZE) then
                playerid = message.secret
                local hero = ShipEntity(love.data.hash("md5", message.secret), tonumber(message.position.x), tonumber(message.position.y), tonumber(message.tm))
                stack:current().eventmanager:fireEvent(HeroEntityChanged(hero))
                stack:current().engine:addEntity(hero)
 
                -- iterate the player list to add other entities
                for id, player in pairs(message.players) do
                    print("got player info for: ", id)
                    stack:current().engine:addEntity(ShipEntity(id, tonumber(player.position.x), tonumber(player.position.y), tonumber(player.team)))
                end
            elseif message.t == FIRE_LASER then
                self.eventmanager:fireEvent(PrimaryWeaponFired(message.pid, tonumber(message.x), tonumber(message.y), tonumber(message.th)))
            elseif message.t == FIRE_MISSILE then
                self.eventmanager:fireEvent(MissileFired(message.pid, tonumber(message.x), tonumber(message.y), tonumber(message.th)))
            elseif message.t == FIRE_MORTAR then
                self.eventmanager:fireEvent(MortarWeaponFired(message.pid, message.ox, message.oy, message.dx, message.dy, message.th))
            elseif message.t == FIRE_BOUNCY then
                self.eventmanager:fireEvent(BouncyWeaponFired(message.pid, tonumber(message.x), tonumber(message.y), tonumber(message.th)))
            elseif message.t == DAMAGE_TAKEN then
                self.eventmanager:fireEvent(ShipDamaged(message.pid, message.damage))
            elseif message.t == DIE then
                self.eventmanager:fireEvent(ShipDestroyed(message.pid, message.kid, message.dpt)) -- dpt = dead pin tile #
            elseif message.t == VELOCITY_CHANGED then
                self.eventmanager:fireEvent(VelocityChanged(message.pid, message.vx, message.vy))
            elseif message.t == FLAG_TAKEN then
                self.eventmanager:fireEvent(FlagTaken(message.pid, message.t, message.tb)) -- t = team, tb = team taken by (T flag taken by TB team)
            elseif message.t == FLAG_DROPPED then
                self.eventmanager:fireEvent(FlagCaptured(message.pid, message.t, message.tb, message.x, message.y)) -- t = team, tb = team taken by (T flag taken by TB team)
            elseif message.t == FLAG_CAPTURED then
                self.eventmanager:fireEvent(FlagCaptured(message.pid, message.t, message.tb)) -- t = team, tb = team taken by (T flag taken by TB team)
            end
        elseif event.type == "connect" then
            print(event.peer, "connected.")
            -- event.peer:send(json.encode({ type = GAME_INITIALIZE, username = "gmreburn" }))
        elseif event.type == "disconnect" then
            print(event.peer, "disconnected.")
        else
            print('idk this event '..event.type)
        end
    end
end

return NetworkSystem