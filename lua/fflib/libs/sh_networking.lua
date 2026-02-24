FFLib.Net = {}
FFLib.NetName = 'FFLib.Net:'
local n = FFLib.Net

function n.Write(name)
    net.Start(FFLib.NetName..name)
end

function n.Get(netString, func)
    net.Receive(FFLib.NetName..netString, function(len, ply)
        if SERVER then
            func(ply)
        elseif CLIENT then
            func(LocalPlayer())
        end
    end)
end

if SERVER then
    function n.Add(netString)
        util.AddNetworkString(FFLib.NetName..netString)
    end

    function n.Everyone()
        net.Broadcast()
    end
end

function n.Send(ply)
    if SERVER then
        net.Send(ply)
    elseif CLIENT then
        net.SendToServer()
    end
end

function n.WEntity(ent)
    net.WriteEntity(ent)
end

function n.REntity()
    return net.ReadEntity()
end

function n.WString(str)
    net.WriteString(str)
end

function n.RString()
    return net.ReadString()
end

function n.WInt(int, num)
    net.WriteInt(int, num)
end

function n.RInt(num)
    return net.ReadInt(num)
end

function n.WUInt(int, bits)
    net.WriteUInt(int, bits)
end

function n.RUInt(bits)
    return net.ReadUInt(bits)
end

function n.WFloat(float)
    net.WriteFloat(float)
end

function n.RFloat()
    return net.ReadFloat()
end

function n.WBool(bool)
    net.WriteBool(bool)
end

function n.RBool()
    return net.ReadBool()
end

function n.WTable(tbl)
    net.WriteTable(tbl)
end

function n.RTable()
    return net.ReadTable()
end

function n.WColor(clr)
    net.WriteColor(clr)
end

function n.RColor()
    return net.ReadColor()
end

function n.WType(type)
    net.WriteType(type)
end

function n.RType()
    return net.ReadType()
end

function n.WVector(vec)
    net.WriteVector(vec)
end

function n.RVector(vec)
    return net.ReadVector()
end