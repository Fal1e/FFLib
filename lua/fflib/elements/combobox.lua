local PANEL = {}

function PANEL:Init()
    self:SetSize(200, 28)
    self.Choices = {}
    self.Selected = nil
    self.IsOpen = false

    self.DropButton = vgui.Create('FFLib.Button', self)
    self.DropButton:SetText('▼')
    self.DropButton:SetWide(28)
    self.DropButton:Dock(RIGHT)
    self.DropButton.DoClick = function()
        self:ToggleDropdown()
    end

    self.Label = vgui.Create('DLabel', self)
    self.Label:Dock(FILL)
    self.Label:SetText('Select...')
    -- self.Label:SetFont('FFfont.20')
    self.Label:SetContentAlignment(4)
    self.Label:SetTextInset(10, 0)
end

function PANEL:AddChoice(text, data)
    table.insert(self.Choices, {text = text, data = data})
end

function PANEL:Clear()
    self.Choices = {}
    if IsValid(self.Dropdown) then self.Dropdown:Remove() end
end

function PANEL:SetSelected(text, data)
    self.Selected = data
    self.Label:SetText(text)
end

function PANEL:GetSelected()
    return self.Selected
end

function PANEL:ToggleDropdown()
    if self.IsOpen then
        if IsValid(self.Dropdown) then self.Dropdown:Remove() end
        self.IsOpen = false
        return
    end

    self.Dropdown = vgui.Create('DPanel')
    local count = #self.Choices
    local w = self:GetWide()
    local optionHeight = 28
    self.Dropdown:SetSize(w, optionHeight * count)
    self.Dropdown:SetPos(self:LocalToScreen(0, self:GetTall()))
    self.Dropdown:SetBackgroundColor(Color(40, 40, 40, 255))
    self.Dropdown:MakePopup()

    for i, opt in ipairs(self.Choices) do
        local btn = vgui.Create('FFLib.Button', self.Dropdown)
        btn:SetText(opt.text)
        btn:SetSize(w, optionHeight)
        btn:SetPos(0, (i - 1) * optionHeight)
        btn.DoClick = function()
            self:SetSelected(opt.text, opt.data)
            if self.OnSelect then
                self:OnSelect(opt.text, opt.data)
            end
            self.Dropdown:Remove()
            self.IsOpen = false
        end
    end

    self.IsOpen = true
end

function PANEL:Paint(w, h)
    FFLib:DrawRoundedBox(6, 0, 0, w, h, FFLib.Theme.Main)
end

FFLib.VGUI:Register('ComboBox', PANEL, 'Panel')