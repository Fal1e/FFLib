FFLib.SCPRP = FFLib.SCPRP || {}
FFLib.SCPRP.Utils = FFLib.SCPRP.Utils || {}

FFLib.SCPRP.Theme = {
    White = Color(220, 220, 220),
    DarkWhite = Color(192, 192, 192),
    Main = Color(28, 28, 28),
    Gray = Color(128, 128, 128),
    DarkGray = Color(64, 64, 64),
}

FFLib.SCPRP.Config = {
    MainPath = 'vangardian/scprp/'
    // Maybe later...
}

FFLib.SCPRP.SCPs = FFLib.SCPRP.SCPs or {}
local SCPs = FFLib.SCPRP.SCPs

SCPs.List = SCPs.List or {}

_G.SCPM = SCPs

function SCPs:Register(id, class)
    assert(isstring(id), "[SCPs] ID объекта должен быть строкой!")

    if SCPs.List[id] then
        return SCPs.List[id]
    end

    local scp = {}
    scp.ID = id
    local classLower = string.lower(class or "")
    
    local classNames = {
        safe = "Безопасный",
        euclid = "Небезопасный", 
        keter = "Опасный"
    }
    
    scp.CLASS = classNames[classLower] or "Неизвестный"

    SCPs.List[id] = scp

    _G[id] = scp

    if SERVER then
        print("[SCPs] Зарегистрирован объект: " .. id)
    end

    return scp
end

function SCPs:Get(id)
    return self.List[id]
end

function SCPs:GetAll()
    return self.List
end