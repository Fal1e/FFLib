vec     = Vector
ang     = Angle
clr     = Color
mat     = Material
mdl     = Model

deg     = math.deg
rad     = math.rad
clamp   = math.Clamp
lerp    = Lerp
rnd     = math.random
abs     = math.abs
sin     = math.sin
cos     = math.cos
sqrt    = math.sqrt

cmd      = concommand
cmdAdd   = concommand.Add
cmdRun   = RunConsoleCommand
cmdAuto  = concommand.AutoComplete

function log(...) MsgC(Color(0,255,0), "[LOG] ", color_white, ..., "\n") end
function warn(...) MsgC(Color(255,128,0), "[WARN] ", color_white, ..., "\n") end
function err(...) MsgC(Color(255,0,0), "[ERROR] ", color_white, ..., "\n") end

function tcopy(t) return table.Copy(t) end
function tcount(t) return table.Count(t) end
function tkeys(t) return table.GetKeys(t) end

white = clr(255,255,255)
black = clr(0,0,0)
red   = clr(255,0,0)
green = clr(0,255,0)
blue  = clr(0,0,255)
gray  = clr(127,127,127)
clear = clr(0,0,0,0)

FFPly = function(index)
    if index ~= nil then return Entity(index)
    elseif CLIENT then return LocalPlayer() end
end

me    = LocalPlayer

if CLIENT then
    TB = TEXT_ALIGN_BOTTOM
    TC = TEXT_ALIGN_CENTER
    TL = TEXT_ALIGN_LEFT
    TR = TEXT_ALIGN_RIGHT
    TT = TEXT_ALIGN_TOP

    DF = FILL
    DL = LEFT
    DR = RIGHT
    DT = TOP
    DB = BOTTOM

    surf = surface
    drawText = draw.SimpleText
    drawRect = surface.DrawRect
    drawbox = draw.RoundedBox
    setCol = surface.SetDrawColor
    setTex = surface.SetTexture
    setMat = surface.SetMaterial
end