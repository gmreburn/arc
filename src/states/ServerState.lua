local ServerState 

local State = require("core/State")
local ServerState = class("ServerState", State)

local enet = require "enet"
local host = nil
local players = {}

function ServerState:load()
    host = enet.host_create("localhost:3000")
    -- load map
end

local onConnect = function(event, peer)
    print(event.peer, "connected.")

    local secret = love.math.random( )
    local playerid = love.data.encode("string", "hex", love.data.hash("md5", secret))
    local payload = {
        type = GAME_INITIALIZE,
        position = {x = 0, y = 0}, -- create vector at dead pen
        team = TEAM_GREEN,
        map = {
            name = "aplgo",
            hash = ""
        },
        players = nil
    }
    players[playerid] = {
        position = payload.position,
        velocity = {},
        username = event.username,
        team = payload.team,
        entity = ShipEntity(playerid, tonumber(players[playerid].position.x), tonumber(players[playerid].position.y), tonumber(players[playerid].team))
    }

    stack:current().engine:addEntity(players[playerid].entity)

    peer:send(JSON.stringify(payload))
    host:broadcast(JSON.stringify({
        type = PLAYER_JOINED,
        username = event.username
    }))
end

local onMessage = function(command, data, peer)
    print("Got message: ", event.data, event.peer)

    if(command == GAME_INITIALIZE) then
        -- do we need this on the server? use it to change the map?
    elseif(command == FIRE_LASER) then
        local playerid = love.data.encode("string", "hex", love.data.hash("md5", love.data.unpack("<n", data)))
        local player = players[playerid]
        local x = love.data.unpack("<xn", data)
        local y = love.data.unpack("<xxn", data)
        local theta = love.data.unpack("<xxxn", data)

        -- check energy level
        if(player.energy >= 1) then
            local startX = player.position.x / 2
            local startY = player.position.y / 2
            
            stack:current().engine:addEntity(Laser(startX, startY, theta, player.team))
        end

        -- send to all connected clients
        host:broadcast(love.data.pack(FIRE_LASER, weapon, playerid, x, y, th))
    elseif(command == FIRE_MISSILE) then
    elseif(command == FIRE_MORTAR) then
    elseif(command == FIRE_BOUNCY) then
    elseif(command == TEAM_CHANGED) then
        local playerid =  love.data.encode("string", "hex", love.data.hash("md5", love.data.unpack("<n", data)))
        local team = love.data.unpack("<xn", data)

        host:broadcast(love.data.pack(TEAM_CHANGED, playerid, team))
    elseif(command == VELOCITY_CHANGED) then
        local playerid =  love.data.encode("string", "hex", love.data.hash("md5", love.data.unpack("<n", data)))
        local x = love.data.unpack("<xn", data)
        local y = love.data.unpack("<xxn", data)

        players[playerid].velocity.x = x
        players[playerid].velocity.y = y

        host:broadcast(love.data.pack(VELOCITY_CHANGED, playerid, x, y))
    elseif(command == FLAG_CAPTURED) then
        -- server should be sending this, no need to receive this message
    elseif(command == FLAG_TAKEN) then
        -- server should be sending this, no need to receive this message
    elseif(command == FLAG_DROPPED) then
        -- server should be sending this, no need to receive this message
    elseif(command == SWITCH_FLIPPED) then
        -- server should be sending this, no need to receive this message
    elseif(command == DIE) then
        -- server should be sending this, no need to receive this message
    elseif(command == DAMAGE_TAKEN) then
        -- server should be sending this, no need to receive this message
    end
end

local onDisconnect = function(event)
    print(event.peer, "disconnected.")
    -- todo: find playerid
    stack:current().engine:removeEntity(players[playerid].entity)
    host:broadcast(JSON.stringify({
        type = PLAYER_LEFT,
        username = event.username
    }))
end

function ServerState:update()
    if(host ~= nil) then
        local event = host:service(100)

        if(event ~= nil) then
            if event.type == "receive" then
                onMessage(love.data.unpack("<B", event.data),  love.data.newByteData(event.data, 1), data.peer)
            elseif event.type == "connect" then
                onConnect(event, peer)
            elseif event.type == "disconnect" then
                onDisconnect(event, peer)
            end
        end
    end
end

return ServerState