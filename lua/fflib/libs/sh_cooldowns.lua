FFLib.CD = FFLib.CD or {}

local _cooldowns = {}

function FFLib.CD:Set(key, time, owner, callback)
    owner = owner or "global"
    local ownerKey = self:_GetKey(owner)
    local fullKey = ownerKey .. "_" .. key
    
    _cooldowns[fullKey] = CurTime() + time
    
    timer.Simple(time + 1, function()
        if _cooldowns[fullKey] and CurTime() > _cooldowns[fullKey] then
            if callback and isfunction(callback) then
                callback(key, owner)
            end
            _cooldowns[fullKey] = nil
        end
    end)
end

function FFLib.CD:Check(key, owner)
    owner = owner or "global"
    local ownerKey = self:_GetKey(owner)
    local fullKey = ownerKey .. "_" .. key
    
    local endTime = _cooldowns[fullKey]
    if not endTime then return false end
    
    if CurTime() > endTime then
        _cooldowns[fullKey] = nil
        return false
    end
    
    return true
end

function FFLib.CD:Get(key, owner)
    owner = owner or "global"
    local ownerKey = self:_GetKey(owner)
    local fullKey = ownerKey .. "_" .. key
    
    local endTime = _cooldowns[fullKey]
    if not endTime or CurTime() > endTime then return 0 end
    
    return math.max(0, endTime - CurTime())
end

function FFLib.CD:Remove(key, owner)
    owner = owner or "global"
    local ownerKey = self:_GetKey(owner)
    local fullKey = ownerKey .. "_" .. key
    
    _cooldowns[fullKey] = nil
end

function FFLib.CD:Clear(owner)
    if not owner then
        table.Empty(_cooldowns)
        return
    end
    
    local ownerKey = self:_GetKey(owner)
    for k in pairs(_cooldowns) do
        if k:StartWith(ownerKey .. "_") then
            _cooldowns[k] = nil
        end
    end
end

function FFLib.CD:_GetKey(owner)
    if isstring(owner) then return owner end
    if not IsValid(owner) then return "invalid" end
    
    if owner:IsPlayer() then
        return "ply_" .. owner:SteamID64()
    end
    
    return "ent_" .. owner:EntIndex()
end

function FFLib.CD:SetPlayer(ply, key, time)
    self:Set(key, time, ply)
end

function FFLib.CD:SetEntity(ent, key, time)
    self:Set(key, time, ent)
end

function FFLib.CD:SetGlobal(key, time)
    self:Set(key, time, "global")
end

function FFLib.CD:CheckPlayer(ply, key)
    return self:Check(key, ply)
end

function FFLib.CD:CheckEntity(ent, key)
    return self:Check(key, ent)
end

function FFLib.CD:CheckGlobal(key)
    return self:Check(key, "global")
end