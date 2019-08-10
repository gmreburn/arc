local PrimaryWeaponFired = require("events/PrimaryWeaponFired")
local json = require("lib/json")

local NetworkSystem = class("NetworkSystem", System)
local enet = require "enet"
local host = enet.host_create()
local playerid = nil
local server = nil

function NetworkSystem:onPrimaryWeaponFired(playerid, x, y, theta)
    -- send update to socket
end

function NetworkSystem:initialize()
    System.initialize(self)
    server = host:connect("localhost:3000")
end

function NetworkSystem:update(dt)
    if(playerid) then
        local event = host:service(100)
        if (event) then
            if event.type == "receive" then
                local message = json.decode(event.data)
                if(message.type == GAME_INITIALIZE) then
                    print("Got message: ", event.data, event.peer)
                    playerid = message.secret
                    print(playerid)
                end
            elseif event.type == "connect" then
                print(event.peer, "connected.")
                -- event.peer:send( "setUserName", "gmrdeburn" )
            elseif event.type == "disconnect" then
                print(event.peer, "disconnected.")
            else
                print('idk this event '..event.type)
            end
        end
    end
end

function serialize (o)
    
end

return NetworkSystem