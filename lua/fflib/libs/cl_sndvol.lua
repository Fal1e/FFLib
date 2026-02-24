
local SOUND_MAX_DISTANCE_GUN = 3000
local SOUND_MAX_DISTANCE_VOICE = 1500

local VOLUME_MULT_GUN = 1.0
local VOLUME_MULT_VOICE = 0.7
local OBSTACLE_MUFFLE = 0.5

local actVoices = {}

FFLib.Net.Get(
    'SndVolShotsTracker',
    function(ply)
        local pos = net.ReadVector()
        local shooter = net.ReadEntity()

        if !IsValid(ply) or !IsValid(shooter) then return end

        local distance = ply:GetPos():Distance(pos)
        if distance > SOUND_MAX_DISTANCE_GUN then return end

        local volume = math.Clamp(1 - (distance / SOUND_MAX_DISTANCE_GUN), 0, 1)
        volume = volume * VOLUME_MULT_GUN

        local tr = util.TraceLine({
            start = ply:EyePos(),
            endpos = pos + Vector(0, 0, 50),
            filter = {ply, shooter}
        })

        if tr.Hit then
            volume = volume * OBSTACLE_MUFFLE
        end

        FFLib.Hook.Run(
            'FFLibOnSndVol',
            'gunshot',
            volume,
            distance,
            shooter,
            pos
        )
    end
)

FFLib.Hook.Add(
    'PlayerStartVoice',
    'SndVolVoiceStart',
    function(ply)
        if IsValid(ply) then
            actVoices[ply] = true
        end
    end
)

FFLib.Hook.Add(
    'PlayerEndVoice',
    'SndVolVoiceEnd',
    function(ply)
        actVoices[ply] = nil
    end
)

FFLib.Hook.Add(
    'Think',
    'SndVolVoiceChecker',
    function()
        if !IsValid(LocalPlayer()) then return end

        for ply in pairs(actVoices) do
            if !IsValid(ply) or !ply:IsSpeaking() then
                actVoices[ply] = nil
                continue
            end

            local distance = LocalPlayer():GetPos():Distance(ply:GetPos())
            if distance > SOUND_MAX_DISTANCE_VOICE then continue end

            local voiceLevel = ply:VoiceVolume() or 0

            local volume = math.Clamp(1 - (distance / SOUND_MAX_DISTANCE_VOICE), 0, 1)
            volume = volume * VOLUME_MULT_VOICE * voiceLevel

            local tr = util.TraceLine({
                start = LocalPlayer():EyePos(),
                endpos = ply:EyePos(),
                filter = {LocalPlayer(), ply}
            })

            if tr.Hit then
                volume = volume * OBSTACLE_MUFFLE
            end

            FFLib.Hook.Run(
                'FFLibOnSndVol',
                'voice',
                volume,
                distance,
                ply,
                ply:GetPos(),
                voiceLevel
            )
        end
    end
)