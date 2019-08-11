local FlagTaken = class("FlagTaken")

function FlagTaken:initialize(playerid, flagTeam, takenByTeam)
    self.playerid = playerid
    self.flagTeam = flagTeam
    self.takenByTeam = takenByTeam
end

return FlagTaken
