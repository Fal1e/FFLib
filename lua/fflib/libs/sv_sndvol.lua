FFLib.Net.Add('SndVolShotsTracker')

FFLib.Hook.Add(
    'EntityFireBullets',
    'SndVolShotsTracker',
    function(ent, data)
        if !FFLib.Player:IsVA(ent) then return end

        FFLib.Net.Write('SndVolShotsTracker')
            FFLib.Net.WVector(data.Src or ent:GetPos()) // Позиция звука
            FFLib.Net.WEntity(ent) // Владелец звука
        FFLib.Net.Everyone()
    end
)