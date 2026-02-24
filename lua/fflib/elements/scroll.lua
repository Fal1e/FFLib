local PANEL = {}

AccessorFunc(PANEL, "m_bFromBottom", "FromBottom", FORCE_BOOL)
AccessorFunc(PANEL, "m_bVBarPadding", "VBarPadding", FORCE_NUMBER)

PANEL:SetVBarPadding(0)

local starting_scroll_speed = 2
local function vbar_OnMouseWheeled(s, delta)
    local panelHeight = s:GetTall()
    local contentHeight = s.CanvasSize
    local scrollMultiplier = math.Clamp(contentHeight / panelHeight, 1, 2)
    
    s.scroll_speed = s.scroll_speed + (RealFrameTime() * 10)
    s:AddScroll(math.Round(delta * -s.scroll_speed * scrollMultiplier * 1.2))
end

local function vbar_SetScroll(s, amount)
    if not s.Enabled then s.Scroll = 0 return end
    s.scroll_target = amount
    s:InvalidateLayout()
end

local function vbar_OnCursorMoved(s, _, y)
    if s.Dragging then
        y = y - s.HoldPos
        y = y / (s:GetTall() - s:GetWide() * 2 - s.btnGrip:GetTall())
        s.scroll_target = y * s.CanvasSize
    end
end

local function vbar_Think(s)
    local frame_time = RealFrameTime() * 10
    local scroll_target = s.scroll_target or 0

    local maxScroll = math.max(0, s.CanvasSize)
    scroll_target = math.Clamp(scroll_target, 0, maxScroll)

    local nextScroll = Lerp(frame_time, s.Scroll or 0, scroll_target)

    if math.abs(nextScroll - scroll_target) < .5 then
        nextScroll = scroll_target
    end

    s.Scroll = math.Clamp(nextScroll, 0, maxScroll)

    if !s.Dragging then
        s.scroll_target = scroll_target
    end

    s.scroll_speed = Lerp(frame_time / 10, s.scroll_speed or starting_scroll_speed, starting_scroll_speed)
end

local function vbar_Paint(s, w, h)
    local parent = s:GetParent()
    if !parent:DrawSkin() then return end
    parent:DrawBackground(w, h)
end

local function vbarGrip_Paint(s, w, h)
    local parent = s.parentPanel
    if !parent:DrawSkin() then return end
    parent:DrawGrip(w, h)
end

local function vbar_PerformLayout(s, w, h)
    local scroll = s:GetScroll() / s.CanvasSize
    local content_ratio = s.CanvasSize > 0 and (s:GetTall() / s.CanvasSize) or 1
    local bar_size = math.Clamp(content_ratio * h, 20, h * 0.9)
    local track = (h - bar_size)
    scroll = scroll * track

    s.btnGrip.y = scroll
    s.btnGrip:SetSize(w, bar_size)
end

function PANEL:Init()
    self:SetSize(400, 100)

    local canvas = self:GetCanvas()

    local vbar = self.VBar
    vbar:SetHideButtons(true)
    vbar.btnUp:SetVisible(false)
    vbar.btnDown:SetVisible(false)

    vbar.scroll_target = 0
    vbar.scroll_speed = starting_scroll_speed

    vbar.OnMouseWheeled = vbar_OnMouseWheeled
    vbar.SetScroll = vbar_SetScroll
    vbar.OnCursorMoved = vbar_OnCursorMoved
    vbar.Think = vbar_Think
    vbar.PerformLayout = vbar_PerformLayout

    vbar.Paint = vbar_Paint

    vbar.btnGrip.parentPanel = self
    vbar.btnGrip.Paint = vbarGrip_Paint
end

function PANEL:DrawBackground(w, h)
    local skin = self:DrawSkin()
    if skin and skin.Scroll and skin.Scroll.Background then
        skin.Scroll.Background(self, w, h)
    end
end

function PANEL:DrawGrip(w, h)
    local skin = self:DrawSkin()
    if skin and skin.Scroll and skin.Scroll.Grip then
        skin.Scroll.Grip(self, w, h)
    end
end

function PANEL:SetScale(scale)
    local w = scale
    self.VBar:SetWide(w)
    self.VBar.btnDown:SetSize(w, 0)
    self.VBar.btnUp:SetSize(w, 0)
end

function PANEL:GetScale()
    return self.VBar:GetWide()
end

function PANEL:ScrollToBottom()
    local vbar = self.VBar
    vbar:SetScroll(vbar.CanvasSize)
end

function PANEL:GetContentHeight()
    local canvas = self.pnlCanvas
    local totalHeight = 0
    local maxY = 0
    
    for _, child in ipairs(canvas:GetChildren()) do
        if IsValid(child) then
            local childY = child.y or 0
            local childTall = child:GetTall()
            maxY = math.max(maxY, childY + childTall)
        end
    end
    
    return maxY
end

function PANEL:AddItem(panel)
    if not IsValid(panel) then return end

    panel:SetParent(self:GetCanvas())
    self:GetCanvas():InvalidateLayout(true)

    if !IsValid(self) then return end
    local totalHeight = 0
    for _, child in ipairs(self:GetCanvas():GetChildren()) do
        if IsValid(child) then
            totalHeight = totalHeight + child:GetTall() + (child.m_bVBarPadding or 0)
        end
    end
    self:GetCanvas():SetTall(math.max(totalHeight, self:GetTall()))
end

function PANEL:PerformLayout(w, h)
    w = w or self:GetWide()
    h = h or self:GetTall()

    local canvas = self.pnlCanvas
    local vbar = self.VBar
    
    canvas:SizeToChildren(false, true)

    local contentHeight = self:GetContentHeight()
    canvas:SetTall(math.max(contentHeight, h))
    
    vbar:SetUp(h, canvas:GetTall())

    local canvasWide = w
    if vbar.Enabled then
        canvasWide = w - vbar:GetWide() - self.m_bVBarPadding
    end
    
    canvas:SetWide(canvasWide)
end

function PANEL:Think()
    local canvas = self.pnlCanvas
    local vbar = self.VBar
    local scroll = vbar.Scroll or 0

    if vbar.Enabled then
        canvas.y = -scroll
    else
        if self:GetFromBottom() then
            canvas.y = self:GetTall() - canvas:GetTall()
        else
            canvas.y = -scroll
        end
    end
end

FFLib.VGUI:Register('Scroll', PANEL, 'DScrollPanel')