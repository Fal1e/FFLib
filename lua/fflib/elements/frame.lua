local PANEL = {}

AccessorFunc(PANEL, 'm_title', 'Title', FORCE_STRING)

function PANEL:OnOpened()
end

function PANEL:Init()
    self:SetAlpha(0)
    self:LerpAlpha(255, .25, function(s)
        s:SetAlpha(255)
        s:OnOpened()
    end)
    self:SetSkin('Default')
    self:SetSize(600, 400)

    self:SetTitle('')
    self:SetDraggable(false)
    self:ShowCloseButton(true)
    
    local headerHeight = 24
    self:DockPadding(4, headerHeight, 4, 4)
end

function PANEL:ShowCloseButton(bool)
    if !bool then
        if IsValid(self.closeButton) then
            self.closeButton:SetVisible(false)
        end
        return
    end

    if !IsValid(self.closeButton) then
        self.closeButton = FFLib.VGUI:Add('Button', self)
        self.closeButton:SetSize(20, 20)
        self.closeButton.Paint = function(s, w, h)
            FFLib:WebImage('https://cdn-icons-png.flaticon.com/512/10728/10728089.png', 0, 0, w, h, Color(255, 255, 255), 0, 0)
        end
        self.closeButton.DoClick = function(s)
            if self.IsDragging then
                self.IsDragging = false
            end
            self:Close()
        end
        return
    end
end

function PANEL:DrawTitle(w, h)
    local skin = self:DrawSkin()
    if skin and skin.Frame and skin.Frame.Title and self:GetTitle() then
        skin.Frame.Title(self, w, h)
    end
end

function PANEL:DrawBackground(w, h)
    local skin = self:DrawSkin()
    if skin and skin.Frame and skin.Frame.Background then
        skin.Frame.Background(self, w, h)
    end
end

function PANEL:SetDraggable(draggable)
    self.Draggable = draggable
    self.IsDragging = false

    if draggable then
        self:SetMouseInputEnabled(true)

        self.OnMousePressed = function(self, mcode)
            if mcode == MOUSE_LEFT then
                self.IsDragging = true
                self.MouseX, self.MouseY = gui.MouseX(), gui.MouseY()
                self.PanelX, self.PanelY = self:GetPos()
            end
        end

        self.OnMouseReleased = function(self, mcode)
            if mcode == MOUSE_LEFT then
                self.IsDragging = false
            end
        end
    else
        self:SetMouseInputEnabled(false)
        self.OnMousePressed = nil
        self.OnMouseReleased = nil
    end
end

function PANEL:Think()
    if self.IsDragging then
        if !input.IsMouseDown(MOUSE_LEFT) then
            self.IsDragging = false
            return
        end

        local mx, my = gui.MouseX(), gui.MouseY()
        local dx, dy = mx - self.MouseX, my - self.MouseY
        self:SetPos(self.PanelX + dx, self.PanelY + dy)
    end
end

function PANEL:PerformLayout()
    if IsValid(self.closeButton) then
        self.closeButton:SetPos(self:GetWide() - 22, 2)
    end
end

function PANEL:OnClosed()
end

function PANEL:Close()
    self:LerpAlpha(0, .25, function(s)
        s:Remove()
        s:OnClosed()
    end)
end

function PANEL:Paint(w, h)
    if !self:DrawSkin() then return end
    self:DrawBackground(w, h)
    self:DrawTitle(w, h)
end

FFLib.VGUI:Register('Frame', PANEL, 'EditablePanel')