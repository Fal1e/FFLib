FFLib.Skin = {}

function FFLib.Skin:Add(name, tbl)
    if !FFLib.SkinsList then
        FFLib.SkinsList = {}
    end
    FFLib.SkinsList[name] = tbl
end

function FFLib.Skin:Find(name)
    return FFLib.SkinsList[name] or FFLib.SkinsList['Default']
end

/*
    НИЖЕ ЗАРЕГИСТРИРОВАН ДЕФОЛТНЫЙ СКИН ДЛЯ ПАНЕЛЕЙ
*/

FFLib.Skin:Add(
    'Default',
    {
        Frame = {
            Background = function(self, w, h)
                FFLib:Mask(function()
                    FFLib:DrawRoundedBox(6, 0, 0, w, h, color_black)
                end,
                function()
                    FFLib:VerticalGradient(0, 0, w, h * 1.25, FFLib.Theme.SLightPurple.r, FFLib.Theme.SLightPurple.g, FFLib.Theme.SLightPurple.b, 255, FFLib.Theme.SemiDarkBlue.r, FFLib.Theme.SemiDarkBlue.g, FFLib.Theme.SemiDarkBlue.b, 255)
                end)
            end,
            Title = function(self, w, h)
                FFLib:DrawShadowText(self:GetTitle(), FFLib.Fonts:Get('default', 22, false), 4, 0, FFLib.Theme.WhiteSkeleton, TEXT_ALIGN_LEFT, 0, 3, 30)
            end,
        },
        Panel = {
            Background = function(self, w, h)
                FFLib:Mask(function()
                    FFLib:DrawRoundedBox(6, 0, 0, w, h, color_black)
                end,
                function()
                    FFLib:VerticalGradient(0, 0, w, h * 1.25, FFLib.Theme.SLightPurple.r, FFLib.Theme.SLightPurple.g, FFLib.Theme.SLightPurple.b, 255, FFLib.Theme.SemiDarkBlue.r, FFLib.Theme.SemiDarkBlue.g, FFLib.Theme.SemiDarkBlue.b, 255)
                end)
            end,
        },
        Button = {
            Background = function(self, w, h)
                FFLib:Mask(function()
                    FFLib:DrawRoundedBox(6, 0, 0, w, h, color_black)
                end,
                function()
                    FFLib:VerticalGradient(0, 0, w, h * 1.25, FFLib.Theme.SLightPurple.r, FFLib.Theme.SLightPurple.g, FFLib.Theme.SLightPurple.b, 255, FFLib.Theme.SemiDarkBlue.r, FFLib.Theme.SemiDarkBlue.g, FFLib.Theme.SemiDarkBlue.b, 255)
                end)
            end,
            Text = function(self, w, h, fSize)
                FFLib:DrawShadowText(self:GetText(), self:GetFont(), w * .5, h * .5, FFLib.Theme.WhiteSkeleton, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, 30)
            end,
        },
        TextEntry = {
            Background = function(self, w, h)
                FFLib:Mask(function()
                    FFLib:DrawRoundedBox(6, 0, 0, w, h, color_black)
                end,
                function()
                    FFLib:VerticalGradient(0, 0, w, h * 1.75, FFLib.Theme.MattPurple.r, FFLib.Theme.MattPurple.g, FFLib.Theme.MattPurple.b, 255, FFLib.Theme.RoyalBlue.r, FFLib.Theme.RoyalBlue.g, FFLib.Theme.RoyalBlue.b, 255)
                end)
            end
        },
        Scroll = {
            Background = function(self, w, h)
                surface.SetDrawColor(FFLib.SCPRP.Theme.Gray)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end,
            Grip = function(self, w, h)
                surface.SetDrawColor(FFLib.SCPRP.Theme.Gray)
                surface.DrawRect(0, 0, w, h)
            end,
        },
        Tooltip = {
            Background = function(self, w, h)
                  FFLib:Mask(function()
                    FFLib:DrawRoundedBox(6, 0, 0, w, h - 8, color_black)
                end,
                function()
                    FFLib:VerticalGradient(0, 0, w, h, 140, 122, 230, 255, 165, 94, 234, 255)
                    FFLib:DrawShadowText(self.Str, FFLib.Fonts:Get('default', 18, false), w * .5, h * .5 - 4, self.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, 30)
                end)
            end,
            Bottom = {
                color_white,
                true
            }
        }
    }
)