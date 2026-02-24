local smoothedOffset = Vector(0, 0, 0)
FFLib.Skin:Add(
    'DarkRP',
    {
        Frame = {
            Title = function(self, w, h)
                FFLib:DrawShadowText(self:GetTitle(), FFLib.Fonts:Get('DarkRP', 22, false), 4, 0, FFLib.Theme.WhiteSkeleton, TEXT_ALIGN_LEFT, 0, 3, 40)
            end,
            Background = function(self, w, h)
                surface.SetDrawColor(0, 0, 0, 100)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(255, 255, 255, 100)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
                -- FFLib:Mask(function()
                --     FFLib:DrawRoundedBox(6, 0, 0, w, h, color_black)
                -- end,
                -- function()
                --     FFLib:VerticalGradient(0, 0, w, h * 1.25, 67, 34, 35, 255, 255, 53, 53, 255)
                -- end)
            end
        },
        Panel = {
            Background = function(self, w, h)
                local maxSize = math.max(w, h)
                FFLib:Mask(function()
                    FFLib:DrawRoundedBox(6, 0, 0, w, h, color_black)
                end,
                function()
                    FFLib:VerticalGradient(0, 0, w, h * 1.25, 67, 34, 35, 255, 255, 53, 53, 255)
                end)
            end
        },
        Button = {
            Background = function(self, w, h)
                surface.SetDrawColor(0, 0, 0, 128)
                surface.DrawRect(0, 0, w, h)
                -- local maxSize = math.max(w, h)
                -- FFLib:Mask(function()
                --     FFLib:DrawRoundedBox(6, 0, 0, w, h, color_black)
                -- end,
                -- function()
                --     FFLib:VerticalGradient(0, 0, w, h * 1.25, 67, 34, 35, 255, 255, 53, 53, 255)
                -- end)
            end,
            Text = function(self, w, h)
                FFLib:DrawShadowText(self:GetText(), self:GetFont(), w * .5, h * .5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, 40)
            end,
        },
        Scroll = {
            Background = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Color(80, 80, 80, 255))
            end,
            Grip = function(self, w, h)
                draw.RoundedBox(6, 0, 0, w, h, FFLib.Theme.LightRed)
            end,
        },
        Tooltip = {
            Background = function(self, w, h)
                  FFLib:Mask(function()
                    FFLib:DrawRoundedBox(6, 0, 0, w, h - 8, color_black)
                end,
                function()
                    FFLib:VerticalGradient(0, 0, w, h * 1.25, 67, 34, 35, 255, 255, 53, 53, 255)
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