local FlagCaptured = class("FlagCaptured")

function FlagCaptured:initialize(playerid, flagTeam, takenByTeam, x, y)
    self.playerid = playerid
    self.flagTeam = flagTeam
    self.takenByTeam = takenByTeam
    self.x = x
    self.y = y
end

return FlagCaptured
