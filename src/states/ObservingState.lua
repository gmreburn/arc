-- this state is used when observing other players

-- States
local GameState = require("states/GameState")
local ObservingState = class("ObservingState", GameState)

local hero = nil

function ObservingState:load()
    State.renderBelow = true
    
    -- stack:push(HeroState())
end

return ObservingState