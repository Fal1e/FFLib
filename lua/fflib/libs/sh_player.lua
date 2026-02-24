FFLib.Player = {}

function FFLib.Player:GetAll()
    return player.GetAll()
end

function FFLib.Player:FindBySteamID(steamID)
    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID() == steamID then 
            return ply
        end
    end
end

function FFLib.Player:FindByName(name)
    for _, ply in ipairs(player.GetAll()) do
        if string.find(string.lower(ply:Nick()), string.lower(name), 1, true) then
            return ply
        end
    end
end

function FFLib.Player:IsVA(ply)
    return IsValid(ply) and ply:Alive()
end