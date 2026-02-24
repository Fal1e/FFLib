local smoothedOffset = Vector(0, 0, 0)
FFLib.Skin:Add(
    'SCPRP',
    {
        Frame = {
            Title = function(self, w, h)
                FFLib:DrawShadowText(self:GetTitle(), FFLib.Fonts:Get('SCPRP', 22, false), 5, 0, FFLib.SCPRP.Theme.White, TEXT_ALIGN_LEFT, 0, 3, 40)
            end,
            Background = function(self, w, h)
                local maxSize = math.max(w, h)
            
                local cx, cy = input.GetCursorPos()
                local lx, ly = self:LocalToScreen(0, 0)
                local relX, relY = cx - (lx + w / 2), cy - (ly + h / 2)
            
                local sensitivity = .04
                local targetOffset = Vector(relX * sensitivity, relY * sensitivity, 0)

                smoothedOffset = LerpVector(FrameTime() * 5, smoothedOffset, targetOffset)
            
                FFLib:VerticalGradient(0, 0, w, h * 1.25,
                    FFLib.SCPRP.Theme.Main.r, FFLib.SCPRP.Theme.Main.g, FFLib.SCPRP.Theme.Main.b, 255,
                    FFLib.SCPRP.Theme.DarkGray.r, FFLib.SCPRP.Theme.DarkGray.g, FFLib.SCPRP.Theme.DarkGray.b, 255
                )
        
                FFLib:WebImageShadow(
                    'https://ia801300.us.archive.org/19/items/o-5-council/O5_Council.png',
                    w * .5 - maxSize * .6 / 2 + smoothedOffset.x,
                    h * .5 - maxSize * .65 / 2 + smoothedOffset.y,
                    maxSize * .6,
                    maxSize * .65,
                    ColorAlpha(color_white, 20),
                    6,
                    ColorAlpha(FFLib.SCPRP.Theme.Main, 50),
                    -16,
                    true
                )

                FFLib:DrawBlur(self, 2)
                surface.SetDrawColor(FFLib.SCPRP.Theme.Gray)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end
        },
        Panel = {
            Background = function(self, w, h)
                FFLib:VerticalGradient(0, 0, w, h * 1.25,
                FFLib.SCPRP.Theme.Main.r, FFLib.SCPRP.Theme.Main.g, FFLib.SCPRP.Theme.Main.b, 128,
                FFLib.SCPRP.Theme.DarkGray.r, FFLib.SCPRP.Theme.DarkGray.g, FFLib.SCPRP.Theme.DarkGray.b, 128
                )
        
                surface.SetDrawColor(FFLib.SCPRP.Theme.Gray)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end
        },
        TextEntry = {
            Background = function(self, w, h)
                FFLib:VerticalGradient(0, 0, w, h * 1.25,
                FFLib.SCPRP.Theme.Main.r, FFLib.SCPRP.Theme.Main.g, FFLib.SCPRP.Theme.Main.b, 128,
                FFLib.SCPRP.Theme.DarkGray.r, FFLib.SCPRP.Theme.DarkGray.g, FFLib.SCPRP.Theme.DarkGray.b, 128
                )
        
                surface.SetDrawColor(FFLib.SCPRP.Theme.Gray)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end
        },
        Button = {
            Background = function(self, w, h)
                FFLib:VerticalGradient(0, 0, w, h * 1.25,
                FFLib.SCPRP.Theme.Main.r, FFLib.SCPRP.Theme.Main.g, FFLib.SCPRP.Theme.Main.b, 128,
                FFLib.SCPRP.Theme.DarkGray.r, FFLib.SCPRP.Theme.DarkGray.g, FFLib.SCPRP.Theme.DarkGray.b, 128
                )
        
                surface.SetDrawColor(FFLib.SCPRP.Theme.Gray)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end,
            Text = function(self, w, h, fSize)
                FFLib:DrawShadowText(self:GetText(), self:GetFont(), w * .5, h * .5, FFLib.SCPRP.Theme.DarkWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, 30)
            end,
        },
        Scroll = {
            Background = function(self, w, h)
                surface.SetDrawColor(FFLib.SCPRP.Theme.DarkGray)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end,
            Grip = function(self, w, h)
                surface.SetDrawColor(FFLib.SCPRP.Theme.Gray)
                surface.DrawRect(0, 0, w, h)
            end,
        }
    }
)