local PlayerJoined = class("PlayerJoined")

function PlayerJoined:initialize(username, team)
    self.username = username
    self.team = team
end

return PlayerJoined