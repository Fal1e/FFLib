local PANEL = {}

function PANEL:Init()
    self:SetSkin('Default')
    self:SetSize(100, 100)
end

function PANEL:DrawBackground(w, h)
    local skin = self:DrawSkin()
    if skin and skin.Panel and skin.Panel.Background then
        skin.Panel.Background(self, w, h)
    end
end

function PANEL:Paint(w, h)
    if !self:DrawSkin() then return end
    self:DrawBackground(w, h)
end

FFLib.VGUI:Register('Panel', PANEL, 'EditablePanel')