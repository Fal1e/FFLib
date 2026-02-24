local PANEL = {}

AccessorFunc(PANEL, 'vertices', 'Vertices', FORCE_NUMBER)
AccessorFunc(PANEL, 'rotation', 'Rotation', FORCE_NUMBER)

function PANEL:Init()
  self.rotation = 0
  self.vertices = 4
  self.scaler   = 1

  self.avatar = vgui.Create('AvatarImage', self)
  self.avatar:SetPaintedManually(true)
end

function PANEL:CalculatePoly(w, h)
  local poly = {}

  if self.vertices == 4 then
    poly = {
      { x =   0, y =   0 },
      { x =   w, y =   0 },
      { x =   w, y =   h },
      { x =   0, y =   h },
    }
  else
    local cx, cy = w * 0.5, h * 0.5 * self.scaler
    local radius = h * 0.5

    for i = 0, self.vertices - 1 do
      local a = math.rad((i / self.vertices) * -360) + self.rotation
      table.insert(poly, {
        x = cx + math.sin(a) * radius,
        y = cy + math.cos(a) * (radius * self.scaler),
      })
    end

    poly[#poly + 1] = {
      x = cx + math.sin(0) * radius,
      y = cy + math.cos(0) * (radius * self.scaler),
    }
  end

  self.data = poly
end

function PANEL:PerformLayout(w, actualH)
  local h = self:GetTall()
  if (self.scaler < 1) then h = h * self.scaler end

  self.avatar:SetPos(0, h - actualH)
  self.avatar:SetSize(self:GetWide(), actualH)
  self:CalculatePoly(self:GetWide(), self:GetTall())
end

function PANEL:SetPlayer(ply, size)
  self.avatar:SetPlayer(ply, size)
end

function PANEL:SetSteamID(sid64, size)
  self.avatar:SetSteamID(sid64, size)
end

function PANEL:DrawPoly(w, h)
  if not self.data then
    self:CalculatePoly(w, h)
  end
  surface.DrawPoly(self.data)
end

function PANEL:Paint(w, h)
  render.ClearStencil()
  render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    draw.NoTexture()
    surface.SetDrawColor(color_white)
    self:DrawPoly(w, h)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    self.avatar:PaintManual()

  render.SetStencilEnable(false)
  render.ClearStencil()
end

FFLib.VGUI:Register('Avatar', PANEL, nil)