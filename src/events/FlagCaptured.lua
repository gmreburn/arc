local FlagCaptured = class("FlagCaptured")

function FlagCaptured:initialize(playerid, flagTeam, takenByTeam)
    self.playerid = playerid
    self.flagTeam = flagTeam
    self.takenByTeam = takenByTeam
end

return FlagCaptured
