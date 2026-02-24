local blur = Material('pp/blurscreen')
function FFLib:DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function FFLib:DrawBlurHUD(x, y, w, h, amt)
	local X, Y = 0, 0

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, amt or 5 do
		blur:SetFloat('$blur', (i / 3) * 5)
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x + w, y + h, true)
		surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

function FFLib:FormatTime(seconds, format)
	if (!seconds) then seconds = 0 end
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds / 60) % 60)
	seconds = math.floor(seconds % 60)

	return string.format(format, hours, minutes, seconds)
end

function FFLib:FormatTime2( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24
	tmp = math.floor( tmp / 24 )
	local d = tmp % 7
	local w = math.floor( tmp / 7 )

	if d>0 and h>0 and m>0 and s>0 then
		return string.format( '%iд %02iч %02iм', d, h, m, s )
	elseif h>0 and m>0 and s>0 then
		return string.format( '%02iч %02iм', h, m, s )
	elseif m>0 and s>0 then
		return string.format( '%2iмин', m, s )
	elseif s>0 then
		return string.format( '%02iсек', s )
	end
end

function LerpColor(progress, color1, color2)
	progress = math.Clamp(progress, 0, 1)

	local r = Lerp(progress, color1.r, color2.r)
	local g = Lerp(progress, color1.g, color2.g)
	local b = Lerp(progress, color1.b, color2.b)
	local a = Lerp(progress, color1.a or 255, color2.a or 255)

	return Color(r, g, b, a)
end

local mat_white = Material('vgui/white')

function draw.SimpleLinearGradient(x, y, w, h, startColor, endColor, horizontal)
	draw.LinearGradient(x, y, w, h, {
		{
			offset = 0,
			color = startColor
		},
		{
			offset = 1,
			color = endColor
		}
	}, horizontal)
end

function draw.LinearGradient(x, y, w, h, stops, horizontal)
	if #stops == 0 then
		return
	elseif #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)
		return
	end

	table.SortByMember(stops, 'offset', true)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)
	for i = 1, #stops - 1 do
		local offset1 = math.Clamp(stops[i].offset, 0, 1)
		local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
		if (offset1 == offset2) then continue end

		local deltaX1, deltaY1, deltaX2, deltaY2

		local color1 = stops[i].color
		local color2 = stops[i + 1].color

		local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
		local r2, g2, b2, a2
		local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
		local r4, g4, b4, a4

		if horizontal then
			r2, g2, b2, a2 = r3, g3, b3, a3
			r4, g4, b4, a4 = r1, g1, b1, a1
			deltaX1 = offset1 * w
			deltaY1 = 0
			deltaX2 = offset2 * w
			deltaY2 = h
		else
			r2, g2, b2, a2 = r1, g1, b1, a1
			r4, g4, b4, a4 = r3, g3, b3, a3
			deltaX1 = 0
			deltaY1 = offset1 * h
			deltaX2 = w
			deltaY2 = offset2 * h
		end

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()

		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end
	mesh.End()
end

function FFLib:HorizontalGradient(x, y, w, h, r1, g1, b1, t1, r2, g2, b2, t2)
    for i = 0, w, 1 do
        surface.SetDrawColor(r1 + i*((r2-r1)/w), g1 + i*((g2-g1)/w), b1 + i*((b2-b1)/w), t1 + i*((t2-t1)/w))
        surface.DrawRect(x+i, y, 1, h)
    end
end

function FFLib:VerticalGradient(x, y, w, h, r1, g1, b1, o1, r2, g2, b2, o2)
	for i = 0, h, 1 do
		surface.SetDrawColor(r1 + i*((r2-r1)/h), g1 + i*((g2-g1)/h), b1 + i*((b2-b1)/h), o1 + i*((o2-o1)/h))
		surface.DrawRect(x, y+i, w, 1)
	end
end

function FFLib:DrawRotatedTexture(x, y, w, h, angle, cx, cy)
	cx, cy = cx or w / 2, cy or w / 2
	if (cx == w / 2 and cy == w / 2) then
		surface.DrawTexturedRectRotated(x, y, w, h, angle)
	else
		local vec = Vector(w / 2 - cx, cy - h / 2, 0)
		vec:Rotate(Angle(180, angle, -180))
		surface.DrawTexturedRectRotated(x - vec.x, y + vec.y, w, h, angle)
	end
end

function FFLib:FormatMoney(number)
	if (number >= 1000000000) then
		return DarkRP.formatMoney(math.Round(number / 1000000000, 2)) .. ' bil'
	elseif (number >= 1000000) then
		return DarkRP.formatMoney(math.Round(number / 1000000, 2)) .. ' mil'
	elseif (number > 10000) then
		return DarkRP.formatMoney(math.Round(number / 1000, 2)) .. 'k'
	end

	return DarkRP.formatMoney(number)
end

function FFLib:DateToString(date)
	if !date then return 'now'end

	local dif = os.ServerTime() - date

	if dif < 60 then
		return 'a moment ago'
	elseif dif < (60 * 60) then
		local mins = math.Round(dif / 60, 0)
		local str = mins .. ' minute' .. (mins == 1 and '' or 's') .. ' ago'

		return str
	elseif dif < (60 * 60) * 24 then
		return os.date('%H:%M', date)
	else
		return os.date('%d/%m/%Y', date)
	end

	return '?'
end

if !FFLib.__AddedPanelFunctions then
	local PNL = FindMetaTable('Panel')
	local Old_Remove = Old_Remove or PNL.Remove

	function PNL:Remove()
		for k, v in pairs(self.hooks or {}) do
			hook.Remove(v.name, k)
		end

		for k, v in pairs(self.timers or {}) do
			timer.Remove(k)
		end

		Old_Remove(self)
	end

	function PNL:AddHook(name, identifier, func)
		identifier = identifier .. ' - ' .. CurTime()

		self.hooks = self.hooks or {}
		self.hooks[identifier] = {
			name = name,
			func = function(...)
				if IsValid(self) then
					return func(self, ...)
				end
			end
		}

		hook.Add(name, identifier, self.hooks[identifier].func)
	end

	function PNL:GetHooks()
		return self.hooks or {}
	end

	function PNL:AddTimer(identifier, delay, rep, func)
		self.timers = self.timers or {}
		self.timers[identifier] = true

		timer.Create(identifier, delay, rep, function(...)
			if IsValid(self) then
				func(self, ...)
			end
		end)
	end

	function PNL:GetTimers()
		return self.timers or {}
	end

	function PNL:LerpAlpha(alpha, time, callback)
		callback = callback or function() end

		self.Alpha = self.Alpha or 0

		local oldThink = self.Think
		self.Think = function(pnl)
			if oldThink then oldThink(pnl)end


			self:SetAlpha(pnl.Alpha >= 250 and 255 or pnl.Alpha)
		end
		self:Lerp('Alpha', alpha, time, function()
			self.Think = oldThink
			callback(self)
		end)
	end

	FFLib.__AddedPanelFunctions = true
end

function FFLib:Wave(speed)
	return (math.cos(CurTime() * speed) + 1) / 2
end


function FFLib:PercentLerp(delay, time, revert)
	local old, new, start = 0, 0, 0

	delay = delay or 0
	time = time or 1

	return function(current, max)
		local ctime = CurTime()

		if revert and current > new then
			new = current
			start = 0
		elseif new ~= current then
			old = Lerp((ctime - start) / time, old, new)
			new = current
			start = ctime + delay
		elseif ctime - start >= time then
			old = current
		end

		local l = Lerp((ctime - start) / time, old, new)
		local p = math.Clamp(l / max, 0, 1)

		return p
	end
end

local function toLines(text, font, mWidth)
	surface.SetFont(font)

	local buffer = {}
	local nLines = {}

	for word in string.gmatch(text, '%S+') do
		local w, h = surface.GetTextSize(table.concat(buffer, ' ') .. ' ' .. word)
		if w > mWidth then
			table.insert(nLines, table.concat(buffer, ' '))
			buffer = {}
		end
		table.insert(buffer, word)
	end

	if #buffer > 0 then
		table.insert(nLines, table.concat(buffer, ' '))
	end

	return nLines
end

local function drawMultiLine(text, font, mWidth, spacing, x, y, color, alignX, alignY, sAmt, sAlpha)
	local mLines = toLines(text, font, mWidth)
	local amt = #mLines - 1
	for i, line in pairs(mLines) do
		if (sAmt and sAlpha) then
			FFLib:DrawShadowText(line, font, x, y + (i - 1) * spacing - amt * spacing / 2, color, alignX, alignY, sAmt, sAlpha)
		else
			draw.SimpleText(line, font, x, y + (i - 1) * spacing - amt * spacing / (alignY == TEXT_ALIGN_CENTER and 2 or 1), color, alignX, alignY)
		end
	end

	return amt * spacing
end

FFLib.DrawMultiLine = drawMultiLine

local matCredit = Material('atlas/credit_small.png', 'smooth')
function FFLib:DrawCreditsText(text, font, x, y, col, xAlign, yAlign, textY, iconColor, spacing)
	textY = textY or 1
	iconColor = iconColor or color_white
	spacing = spacing or 4

	surface.SetFont(font)
	local tw, th = surface.GetTextSize(text)
	local size = th
	if (xAlign == TEXT_ALIGN_LEFT) then
		surface.SetMaterial(matCredit)
		surface.SetDrawColor(iconColor)
		surface.DrawTexturedRect(x, y, size, size)

		draw.SimpleText(text, font, x + size + spacing, y + textY, col, xAlign, yAlign)
	elseif (xAlign == TEXT_ALIGN_CENTER) then
		x = x + size / 2 + 2

		surface.SetMaterial(matCredit)
		surface.SetDrawColor(iconColor)
		surface.DrawTexturedRect(x - tw / 2 - size - spacing, y, size, size)

		draw.SimpleText(text, font, x, y + textY, col, xAlign, yAlign)
	elseif (xAlign == TEXT_ALIGN_RIGHT) then
		x = x + size / 2 + 2

		surface.SetMaterial(matCredit)
		surface.SetDrawColor(iconColor)
		surface.DrawTexturedRect(x - tw - size - spacing, y, size, size)

		draw.SimpleText(text, font, x, y + textY, col, xAlign, yAlign)
	end
end

function FFLib:DrawArc(x, y, ang, p, rad, color, seg)
	seg = seg or 80
	ang = (-ang) + 180
	local circle = {}

	table.insert(circle, {
		x = x,
		y = y
	})
	for i = 0, seg do
		local a = math.rad((i / seg) * -p + ang)
		table.insert(circle, {
			x = x + math.sin(a) * rad,
			y = y + math.cos(a) * rad
		})
	end

	surface.SetDrawColor(color)
	draw.NoTexture()
	surface.DrawPoly(circle)
end

function FFLib:CalculateArc(x, y, ang, p, rad, seg)
	seg = seg or 80
	ang = (-ang) + 180
	local circle = {}

	table.insert(circle, {
		x = x,
		y = y
	})
	for i = 0, seg do
		local a = math.rad((i / seg) * -p + ang)
		table.insert(circle, {
			x = x + math.sin(a) * rad,
			y = y + math.cos(a) * rad
		})
	end

	return circle
end

function FFLib:DrawCachedArc(circle, color)
	surface.SetDrawColor(color)
	draw.NoTexture()
	surface.DrawPoly(circle)
end

function FFLib:DrawRoundedBoxEx(radius, x, y, w, h, col, tl, tr, bl, br)

	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)
	radius = math.Clamp(math.floor(radius), 0, math.min(h / 2, w / 2))

	if (radius == 0) then
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, w, h)

		return
	end


	surface.SetDrawColor(col)
	surface.DrawRect(x + radius, y, w - radius * 2, radius)
	surface.DrawRect(x, y + radius, w, h - radius * 2)
	surface.DrawRect(x + radius, y + h - radius, w - radius * 2, radius)


	if tl then
		FFLib:DrawArc(x + radius, y + radius, 270, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, radius, radius)
	end

	if tr then
		FFLib:DrawArc(x + w - radius, y + radius, 0, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x + w - radius, y, radius, radius)
	end

	if bl then
		FFLib:DrawArc(x + radius, y + h - radius, 180, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x, y + h - radius, radius, radius)
	end

	if br then
		FFLib:DrawArc(x + w - radius, y + h - radius, 90, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x + w - radius, y + h - radius, radius, radius)
	end
end

function FFLib:DrawRoundedBox(radius, x, y, w, h, col)
	FFLib:DrawRoundedBoxEx(radius, x, y, w, h, col, true, true, true, true)
end

function FFLib:MaskInverse(maskFn, drawFn, pixel)
	pixel = pixel or 1

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(pixel)

	maskFn()

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(pixel - 1)

	drawFn()

	render.SetStencilEnable(false)
	render.ClearStencil()
end

function FFLib:Mask(maskFn, drawFn, pixel)
	pixel = pixel or 1

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(pixel)

	maskFn()

	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(pixel)

	drawFn()

	render.SetStencilEnable(false)
	render.ClearStencil()
end

function FFLib:DrawShadowText(text, font, x, y, col, xAlign, yAlign, amt, shadow, color)
	color = color or color_black
	for i = 1, amt do
		draw.SimpleText(text, font, x + i, y + i, Color(color.r, color.g, color.b, i * (shadow or 50)), xAlign, yAlign)
	end

	draw.SimpleText(text, font, x, y, col, xAlign, yAlign)
end

function FFLib:DrawOutlinedText(str, font, x, y, col, xAlign, yAlign, outlineCol, thickness)
	thickness = thickness or 1

	for i = 1, thickness do
		draw.SimpleText(str, font, x - thickness, y - thickness, outlineCol or color_black, xAlign, yAlign)
		draw.SimpleText(str, font, x - thickness, y + thickness, outlineCol or color_black, xAlign, yAlign)
		draw.SimpleText(str, font, x + thickness, y - thickness, outlineCol or color_black, xAlign, yAlign)
		draw.SimpleText(str, font, x + thickness, y + thickness, outlineCol or color_black, xAlign, yAlign)
	end

	draw.SimpleText(str, font, x, y, col, xAlign, yAlign)
end

function FFLib:DrawHollowArc(cx, cy, radius, thickness, startang, endang, roughness, color)
	surface.SetDrawColor(color)

	local arc = self:CacheHollowArc(cx, cy, radius, thickness, startang, endang, roughness)

	for i, vertex in pairs(arc) do
		surface.DrawPoly(vertex)
	end
end

function FFLib:CacheHollowArc(cx, cy, radius, thickness, startang, endang, roughness)
	local triarc = {}

	local roughness = math.max(roughness or 1, 1)
	local step = roughness


	local startang, endang = startang or 0, endang or 0

	if startang > endang then
		step = math.abs(step) * -1
	end


	local inner = {}
	local r = radius - thickness
	for deg = startang, endang, step do
		local rad = math.rad(deg)

		local ox, oy = cx + (math.cos(rad) * r), cy + (-math.sin(rad) * r)
		table.insert(inner, {
			x = ox,
			y = oy,
			u = (ox - cx) / radius + .5,
			v = (oy - cy) / radius + .5
		})
	end

	local outer = {}
	for deg = startang, endang, step do
		local rad = math.rad(deg)

		local ox, oy = cx + (math.cos(rad) * radius), cy + (-math.sin(rad) * radius)
		table.insert(outer, {
			x = ox,
			y = oy,
			u = (ox - cx) / radius + .5,
			v = (oy - cy) / radius + .5
		})
	end

	for tri = 1, #inner * 2 do
		local p1, p2, p3
		p1 = outer[math.floor(tri / 2) + 1]
		p3 = inner[math.floor((tri + 1) / 2) + 1]
		if tri % 2 == 0 then
			p2 = outer[math.floor((tri + 1) / 2)]
		else
			p2 = inner[math.floor((tri + 1) / 2)]
		end

		table.insert(triarc, {
			p1,
			p2,
			p3
		})
	end

	return triarc
end

function FFLib:DualText(title, subtitle, x, y, w, h)
	x = x or 0
	y = y or 0

	surface.SetFont(title[2])
	local tW, tH = surface.GetTextSize(title[1])

	surface.SetFont(subtitle[2])
	local sW, sH = surface.GetTextSize(subtitle[1])

	FFLib:DrawShadowText(title[1], title[2], x, y + (h / 2 - sH / 2), title[3], title[4], TEXT_ALIGN_CENTER, title[5], title[6])
	FFLib:DrawShadowText(subtitle[1], subtitle[2], x, y + (h / 2 + tH / 2), subtitle[3], subtitle[4], TEXT_ALIGN_CENTER, subtitle[5], subtitle[6])
end

function FFLib:TextInBox(text, font, x, y, color, align, radius, boxcolor, w, h)
	w = w or 0
	h = h or 0
	boxcolor = boxcolor or Color(45,45,45)

	local tW, tH = self.Fonts:TextSize(text, font)
	local xPos = x - 10 // TEXT_ALIGN_LEFT
	if align == (TEXT_ALIGN_CENTER or TEXT_ALIGN_CENTER) then
		xPos = x - tW + (tW * .5 - 10)
	elseif align == (TEXT_ALIGN_RIGHT or TEXT_ALIGN_RIGHT) then
		xPos = x - tW - 10
	end

	FFLib:DrawRoundedBox(radius, xPos, y - tH/2, w, tH + 5 + h, boxcolor)
	FFLib:DrawShadowText(text, font, x, y + 2, color, align, TEXT_ALIGN_CENTER, 4, 20)
end

function FFLib:TextInBoxWithIcon(text, font, botherXY, x, y, color, align, radius, boxcolor, w, h, bldrawmat, maturl, matPosX, matPosY, matSizeW, matSizeH, matColor)
	matPosX = matPosX and matPosX + x or x
	matPosY = matPosY and matPosY + y or y
	matSizeW = matSizeW or 0
	matSizeH = matSizeH or 0
	w = w or 0
	h = h or 0
	matColor = matColor or color_white
	boxcolor = boxcolor or Color(45,45,45)
	
	surface.SetFont(font)
	local tW, tH = surface.GetTextSize(text)
	local xPos = x - 10 // TEXT_ALIGN_LEFT
	if botherXY then
		if align == (TEXT_ALIGN_CENTER or TEXT_ALIGN_CENTER) then
			xPos = x/2 + tW - 15
		elseif align == (TEXT_ALIGN_RIGHT or TEXT_ALIGN_RIGHT) then
			xPos = x - tW - 10
		end
	else
		if align == (TEXT_ALIGN_CENTER or TEXT_ALIGN_CENTER) then
			xPos = x/2 + tW - 15
		elseif align == (TEXT_ALIGN_RIGHT or TEXT_ALIGN_RIGHT) then
			xPos = x - tW - 10
		end
	end

	if boxcolor == FFLib.Theme.Green then
		FFLib:DrawRoundedBox(radius, xPos - 12, y - tH/2, w + 10, tH + 5 + h, boxcolor)
	else
		FFLib:DrawRoundedBox(radius, xPos - 12, y - tH/2, w + 12, tH + 5 + h, boxcolor)
	end
	if bldrawmat then
		FFLib:WebImage(maturl, matPosX, matPosY, matSizeW, matSizeH, matColor)
	end
	if boxcolor == FFLib.Theme.Green then
		FFLib:DrawShadowText(text, font, x + 10, y + 2, color, align, TEXT_ALIGN_CENTER, 4, 20)
	else
		FFLib:DrawShadowText(text, font, x + 4, y + 2, color, align, TEXT_ALIGN_CENTER, 4, 20)
	end
end

function FFLib:DrawIconRotated(x, y, w, h, rotation, pnl, col, loadCol)
	col = col or color_white
	loadCol = loadCol or FFLib.Theme.Accent

	if (pnl.Icon and type(pnl.Icon) == 'IMaterial') then
		surface.SetMaterial(pnl.Icon)
		surface.SetDrawColor(col)
		FFLib:DrawRotatedTexture(x, y, w, h, rotation)
	elseif (pnl.Icon != nil) then
		FFLib:DrawLoadingCircle(h, h, h, loadCol)
	end
end

local Layouts = {}

function LerpText(id, text, speed, sounded, adv)
    if not Layouts[id] then
        Layouts[id] = {
            text = text,
            pos = 0,
            length = utf8.len(text)
        }
    else
        if Layouts[id].text ~= text then
            Layouts[id].text = text
            Layouts[id].length = utf8.len(text)
            Layouts[id].pos = 0
        end
    end

    local s = Layouts[id]
    
    timer.Remove(id .. "_remove")
    
    if not timer.Exists("AdvanceText_" .. id) and not IsShowed(id) then
        timer.Create("AdvanceText_" .. id, speed, s.length, function()
            s.pos = s.pos + 1
            
            if isbool(sounded) or adv then
				LocalPlayer():EmitSound('vangardianrp/darkrp/ui/notify_1.mp3', 50, 128, 0.05, CHAN_AUTO)
            end
        end)
    end

    local displayedText = utf8.sub(s.text, 1, s.pos)
    
    if s.pos < s.length then
        if isstring(sounded) then
            displayedText = displayedText .. sounded
        elseif istable(sounded) then
            local symbol = table.Random(sounded)
            displayedText = displayedText .. symbol
        end
    end
    
    return displayedText
end

function StopShowing(id)
    Layouts[id] = nil
    timer.Remove("AdvanceText_" .. id)
    timer.Remove(id .. "_remove")
end

function IsShowed(id)
    local s = Layouts[id]
    
    if not s then
        return false
    end
    
    return s.pos >= s.length
end

function GetTextProgress(id)
    local s = Layouts[id]
    
    if not s then
        return 0
    end
    
    if s.length == 0 then
        return 100
    end
    
    return math.Round((s.pos / s.length) * 100)
end

function SkipText(id)
    local s = Layouts[id]
    
    if not s then
        return
    end
    
    s.pos = s.length
    timer.Remove("AdvanceText_" .. id)
end

function ResetText(id)
    if Layouts[id] then
        Layouts[id].pos = 0
        timer.Remove("AdvanceText_" .. id)
    end
end

hook.Add("PreDrawEffects", "FFLib.Draw.Entities", function()
	for _, ent in pairs(ents.GetAll()) do
        if IsValid(ent) then
            local meta = ent:GetTable()
            if meta and meta.DrawUI and type(meta.DrawUI) == "function" then
                ent:DrawUI()
            end
        end
    end
end)


/*
	OLDTEST
*/
-- ui = ui or {}
-- ui.utils = {}

-- -- function ui.setfont(size)
-- --     return 'FalFont.'..math.Round(ScreenScale(size))
-- -- end

-- function ui.utils.size(w,h)
-- 	w = ScrW() * (w / 1920)
-- 	h = ScrH() * (h / 1080)
-- 	return w, h
-- end

-- function ui.utils.GetTextSize(txt,font)
-- 	surface.SetFont(font)
-- 	return surface.GetTextSize(txt)
-- end