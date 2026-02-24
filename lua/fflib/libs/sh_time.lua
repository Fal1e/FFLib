FFLib.Time = {}

function FFLib.Time:Cur()
    return CurTime()
end

function FFLib.Time:Sys()
    return SysTime()
end

function FFLib.Time:Real()
    return RealTime()
end

function FFLib.Time:Frame()
    return FrameTime()
end