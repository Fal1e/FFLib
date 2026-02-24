FFLib.Distance = {}

function FFLib.Distance:Squared(v1, v2)
    return v1:DistToSqr(v2)
end

function FFLib.Distance:Normal(v1, v2)
    return v1:Distance(v2)
end

function FFLib.Distance:Within(v1, v2, range)
    return v1:DistToSqr(v2) <= (range * range)
end

function FFLib.Distance:SqrDistance(ent, owner, range)
    if !IsValid(ent) or !IsValid(owner) then return false end
    return ent:GetPos():DistToSqr(owner:GetPos()) <= (range * range)
end

function FFLib.Distance:Distance(ent, owner, range)
    if !IsValid(ent) or !IsValid(owner) then return false end
    return ent:GetPos():Distance(owner:GetPos()) <= range
end