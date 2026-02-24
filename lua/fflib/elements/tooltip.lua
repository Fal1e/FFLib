local PanelMeta = FindMetaTable('Panel')

local toolTipCreated = false
function PanelMeta:RemoveCooltip()
  if IsValid(self.Tooltip) then
    toolTipCreated = false
    self.Tooltip:Hide()
  end

  self.EnableTooltip = false
end

function PanelMeta:FFToolTip(str, skin, font, delay, offsetX, offsetY)
  self.EnableTooltip = true
  self.CursorEntered = 0
  self.ActivateTooltip = true
  self.TooltipStr = str
  self.TooltipDelay = delay or 0.2

  if self.Tooltip then
	  self.Tooltip.Str = str
    local x, y = self:LocalToScreen(offsetX or 0, offsetY or 0)
    local width, height = FFLib.Fonts:TextSize(self.TooltipStr, font or FFLib.Fonts:Get('default', 18, false))

    self.Tooltip:SetSize(width + 32, height + 24)
    self.Tooltip:SetPos(x + self:GetWide() / 2 - self.Tooltip:GetWide() / 2, y - self.Tooltip:GetTall() - 4)

    self.Tooltip:Show()
    return
  end

  local oldCursorEntered = self.OnCursorEntered
  self.OnCursorEntered = function(pnl)
    if oldCursorEntered then oldCursorEntered(pnl)end

    pnl.CursorEntered = CurTime() + pnl.TooltipDelay
  end

  local oldCursorExited = self.OnCursorExited
  self.OnCursorExited = function(pnl)
    if oldCursorExited then oldCursorExited(pnl)end

    pnl.CursorEntered = 0

    toolTipCreated = false
    if IsValid(pnl.Tooltip) then
      toolTipCreated = false
      pnl.Tooltip:Remove()
      pnl.Tooltip = nil
    end
  end

  local oldThink = self.Think
  self.Think = function(pnl)
      if oldThink then oldThink(pnl) end

      if pnl.CursorEntered < CurTime() and not IsValid(pnl.Tooltip) and pnl:IsHovered() and pnl.EnableTooltip then
          if not toolTipCreated then
              toolTipCreated = true
              
              local x, y = pnl:LocalToScreen(offsetX or 0, offsetY or 0)
              local w = pnl:GetWide()

              surface.SetFont(FFLib.Fonts:Get('default', 18, false))
              local width, height = surface.GetTextSize(self.TooltipStr)

              pnl.Tooltip = vgui.Create('FFLib.Tooltip')
              pnl.Tooltip:SetSkin(skin or "Default")
              pnl.Tooltip:SetAlpha(0)
              pnl.Tooltip:SetDrawOnTop(true)
              pnl.Tooltip:SetSize(width + 32, height + 24)
              pnl.Tooltip:SetPos(x + self:GetWide() / 2 - pnl.Tooltip:GetWide() / 2, y - pnl.Tooltip:GetTall() - 4)
              pnl.Tooltip:AlphaTo(255, 0.15)
              pnl.Tooltip.Str = str
          end
      end
  end

  local oldRemove = self.OnRemove
  self.OnRemove = function(pnl)
    if oldRemove then oldRemove(pnl)end

    if IsValid(pnl.Tooltip) then
      pnl.Tooltip:Remove()
    end
  end
end

function PanelMeta:FFToolTipString(str)
  self.TooltipStr = str
  if (!IsValid(self.Tooltip)) then return end
  self.Tooltip.Str = str

  local x, y = self:LocalToScreen(0, 0)
  local w = self:GetWide()

  surface.SetFont(FFLib.Fonts:Get('default', 18, false))
  local width, height = surface.GetTextSize(self.TooltipStr)

  self.Tooltip:SetSize(width + 32, height + 24)
  self.Tooltip:SetPos(x + self:GetWide() / 2 - self.Tooltip:GetWide() / 2, y - self.Tooltip:GetTall() - 4)
end

local PANEL = {}

function PANEL:Init()
  self:SetSkin("Default")
end

function PANEL:Paint(w, h)
  local skin = self:DrawSkin()
  if skin and skin.Tooltip and skin.Tooltip.Background then
      skin.Tooltip.Background(self, w, h)
  end

  local tbl = {
    {
      x = w / 2 - 8,
      y = h - 8
    },
    {
      x = w / 2 + 8,
      y = h - 8
    },
    {
      x = w / 2,
      y = h
    },
    {
      x = w / 2 - 8,
      y = h - 8
    }
  }

  if skin and skin.Tooltip and skin.Tooltip.Bottom and skin.Tooltip.Bottom[2] then
    draw.NoTexture()
    surface.SetDrawColor(skin.Tooltip.Bottom[1] or color_white)
    surface.DrawPoly(tbl)
  end
end

FFLib.VGUI:Register('Tooltip', PANEL, 'EditablePanel')