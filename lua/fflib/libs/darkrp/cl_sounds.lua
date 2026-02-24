function FFLib.DarkRP.Utils:SoundPress(num, snd, pth, vol) // Press sound
    if !LocalPlayer():IsValid() then return end
    local num = num or 1
    local snd = snd or 35
    local pth = pth or 100
    local vol = vol or 1
    LocalPlayer():EmitSound(FFLib.DarkRP.Config.MainPath..'ui/click_'..num..'.mp3', snd, pth, vol, CHAN_AUTO)
end

function FFLib.DarkRP.Utils:SoundError(num, snd, pth, vol) // Error sound
    if !LocalPlayer():IsValid() then return end
    local num = num or 1
    local snd = snd or 35
    local pth = pth or 100
    local vol = vol or 1
    LocalPlayer():EmitSound(FFLib.DarkRP.Config.MainPath..'ui/error_'..num..'.mp3', snd, pth, vol, CHAN_AUTO)
end

function FFLib.DarkRP.Utils:SoundSuccess(num, snd, pth, vol) // Success sound
    if !LocalPlayer():IsValid() then return end
    local num = num or 1
    local snd = snd or 35
    local pth = pth or 100
    local vol = vol or 1
    LocalPlayer():EmitSound(FFLib.DarkRP.Config.MainPath..'ui/success_'..num..'.mp3', snd, pth, vol, CHAN_AUTO)
end

function FFLib.DarkRP.Utils:SoundNotify(num, snd, pth, vol) // Notify sound
    if !LocalPlayer():IsValid() then return end
    local num = num or 1
    local snd = snd or 35
    local pth = pth or 100
    local vol = vol or 1
    LocalPlayer():EmitSound(FFLib.DarkRP.Config.MainPath..'ui/notify_'..num..'.mp3', snd, pth, vol, CHAN_AUTO)
end

function FFLib.DarkRP.Utils:SoundDraw(num, snd, pth, vol) // Draw sound
    if !LocalPlayer():IsValid() then return end
    local num = num or 1
    local snd = snd or 35
    local pth = pth or 100
    local vol = vol or 1
    LocalPlayer():EmitSound(FFLib.DarkRP.Config.MainPath..'ui/draw_'..num..'.mp3', snd, pth, vol, CHAN_AUTO)
end