if SERVER then
    function FFLib:Notify(ply, msgtype, len, msg)
        if not istable(ply) then
            if not IsValid(ply) then
                print(msg)
                return
            end
            ply = {ply}
        end

        local rcp = RecipientFilter()
        for _, v in pairs(ply) do
            rcp:AddPlayer(v)
        end

        if hook.Run("onNotify", rcp:GetPlayers(), msgtype, len, msg) == true then return end

        umsg.Start("FFLib:Notify", rcp)
            umsg.String(msg)
            umsg.Short(msgtype)
            umsg.Long(len)
        umsg.End()
    end
end

if CLIENT then
    local function FFLib_Notify(msg)
        local txt = msg:ReadString()
        GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
        
        MsgC(Color(126, 64, 174), '[FFLib] ', Color(200, 200, 200, 255), txt, "\n")
    end
    usermessage.Hook('FFLib:Notify', FFLib_Notify)
end

PLAYER = FindMetaTable('Player')

function PLAYER:SendNotify(type, seconds, text)
	if CLIENT then
		notification.AddLegacy(text, type, seconds)
	else
		FFLib:Notify(self, type, seconds, text)
	end
end