FFLib.VGUI = {}

local PANEL = FindMetaTable('Panel')

function PANEL:SetSkin(string)
    self.Skin = string
end

function PANEL:DrawSkin()
    local skin = FFLib.Skin:Find(self.Skin)
    return skin
end

local function applyMethod(element, method, args)
    if element[method] then
        if type(args) == 'table' then
            element[method](element, unpack(args))
        else
            element[method](element, args)
        end
    end
end

function FFLib.VGUI:Add(elementType, parent)
    local element = vgui.Create('FFLib.' .. elementType, parent)
    return element
end

function FFLib.VGUI:Register(className, pnlTable, baseName)
    if !isstring(className) or className == '' then return end
    if !istable(pnlTable) then return end
    if baseName and !isstring(baseName) then return end

    baseName = baseName or 'Panel'
    className = 'FFLib.' .. className

    vgui.Register(className, pnlTable, baseName)
end