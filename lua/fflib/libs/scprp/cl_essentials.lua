function FFLib.SCPRP:DrawBox(x, y, w, h, clr1, clr2, outEba, clrOut)
    FFLib:VerticalGradient(x, y, w, h - 1,
        clr1 and clr1.r or FFLib.SCPRP.Theme.Main.r, clr1 and clr1.g or FFLib.SCPRP.Theme.Main.g, clr1 and clr1.b or FFLib.SCPRP.Theme.Main.b, clr1 and clr1.a or 255,
        clr2 and clr2.r or FFLib.SCPRP.Theme.DarkGray.r, clr2 and clr2.g or FFLib.SCPRP.Theme.DarkGray.g, clr2 and clr2.b or FFLib.SCPRP.Theme.DarkGray.b, clr2 and clr2.a or 255
    )

    if outEba == nil then
        outEba = true
    end

    if outEba then
        surface.SetDrawColor(clrOut and clrOut or FFLib.SCPRP.Theme.Gray)
        surface.DrawOutlinedRect(x, y, w, h, 1)
    end
end

function FFLib.SCPRP:DrawKeyHints(centerX, baseY, hints)
    if not hints or #hints < 1 then return end

    local spacing = 70
    local count = #hints

    for i, hint in ipairs(hints) do
        local offset = 0
        if count % 2 == 0 then
            local middleLeft = count / 2
            offset = (i - middleLeft - 0.5) * spacing
        else
            local middle = math.ceil(count / 2)
            offset = (i - middle) * spacing
        end

        local boxX, boxY = centerX + offset, baseY
        local boxW, boxH = 60, 40

        local cooldownText = (hint.var and hint.var > CurTime()) and math.Round(hint.var - CurTime())..' сек' or 'Готово'
        local text = hint.text or (hint.check and 'Активно' or cooldownText)
        local textColor = hint.textColor or (hint.check and FFLib.Theme.FaraonOrange or ((cooldownText == 'Готово') and FFLib.Theme.LightGreen or FFLib.Theme.LightRed))

        FFLib.SCPRP:DrawBox(boxX - boxW / 2, boxY - boxH / 2, boxW, boxH, FFLib.Theme.DeepOrange, nil, true, nil)
        FFLib:DrawShadowText(hint.key, FFLib.Fonts:Get('SCPRP', 28, false), boxX, boxY, FFLib.SCPRP.Theme.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2)

        local font = FFLib.Fonts:Get('SCPRP', 19, false)
        local maxW = boxW
        local words = {}

        for word in hint.title:gmatch("%S+") do
            if FFLib.Fonts:TextSize(word, font) > maxW then
                local temp = ""
                for c in word:gmatch(".") do
                    local test = temp .. c
                    if FFLib.Fonts:TextSize(test, font) > maxW then
                        table.insert(words, temp)
                        temp = c
                    else
                        temp = test
                    end
                end
                if temp ~= "" then table.insert(words, temp) end
            else
                table.insert(words, word)
            end
        end

        local font = FFLib.Fonts:Get('SCPRP', 19, false)
        local maxW = boxW
        local lines = {}
        local line = ""

        for c in hint.title:gmatch(".") do
            local testLine = line .. c
            if FFLib.Fonts:TextSize(testLine, font) > maxW then
                table.insert(lines, line)
                line = c
            else
                line = testLine
            end
        end
        if line ~= "" then table.insert(lines, line) end

        local _, textH = FFLib.Fonts:TextSize("A", font)
        local startY = boxY - boxH / 2 - 12 - (#lines - 1) * textH
        for j, l in ipairs(lines) do
            local yPosLine = startY + (j - 1) * textH
            FFLib:DrawShadowText(l, font, boxX, yPosLine, FFLib.SCPRP.Theme.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2)
        end

        local wText, hText = FFLib.Fonts:TextSize(text, FFLib.Fonts:Get('SCPRP', 17, false))
        FFLib:DrawShadowText(text, FFLib.Fonts:Get('SCPRP', 17, false), boxX, boxY + boxH / 2 + hText / 2 + 4, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2)
    end
end

FFLib.SCPRP.ActivePhrase = nil
FFLib.SCPRP.LastPhraseTime = 0

function FFLib.SCPRP:AddPhrase(text, font, cd, duration, x, y, color)
    if !text or text == "" then return end

    font = font or FFLib.Fonts:Get('SCPRP', 24, false)
    cd = cd or 5
    duration = duration or 3
    x = x or ScrW() * 0.5
    y = y or ScrH() * 0.3
    color = color or self.Theme.DarkWhite

    if !self.ActivePhrase and CurTime() - self.LastPhraseTime >= cd then
        self.ActivePhrase = {
            text = text,
            x = x,
            y = y,
            color = Color(color.r, color.g, color.b, 0),
            duration = duration,
            time = CurTime(),
            font = font
        }
        self.LastPhraseTime = CurTime()
    end

    if self.ActivePhrase then
        local elapsed = CurTime() - self.ActivePhrase.time
        if elapsed > self.ActivePhrase.duration then
            self.ActivePhrase = nil
        else
            local alpha = 255
            if elapsed < 0.5 then
                alpha = math.Clamp(elapsed / 0.5 * 255, 0, 255)
            elseif elapsed > self.ActivePhrase.duration - 0.5 then
                alpha = math.Clamp((self.ActivePhrase.duration - elapsed) / 0.5 * 255, 0, 255)
            end
            self.ActivePhrase.color.a = alpha
        end
    end
end

function FFLib.SCPRP:DrawPhrases()
    if not self.ActivePhrase then return end
    local p = self.ActivePhrase
    FFLib:DrawShadowText(p.text, p.font, p.x, p.y, p.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2)
end