FFLib.Fonts = FFLib.Fonts or {}

local registry, created = {}, {}
local DEFAULT_MIN_SIZE, DEFAULT_MAX_SIZE = 8, 64

function FFLib.Fonts:Register(key, fontName, weight, extended)
    registry[key] = {
        fontName = fontName,
        weight   = weight   or 500,
        extended = extended or false,
    }
end

function FFLib.Fonts:Get(key, size, scalable, min, max)
    local data = registry[key]
    if not data then
        error("FFLib.Fonts: font '" .. tostring(key) .. "' is not registered")
    end

    if min == nil then
        min = math.max(DEFAULT_MIN_SIZE, math.floor(size * 0.5))
        
        local ABSOLUTE_MIN = 8
        if min < ABSOLUTE_MIN and size > ABSOLUTE_MIN then
            min = ABSOLUTE_MIN
        end
    end
    
    if max == nil then
        max = math.min(DEFAULT_MAX_SIZE, math.ceil(size * 1.5))
    end

    min = math.max(1, min)
    max = math.max(1, max)
    
    if min > max then
        local avg = math.floor((min + max) / 2)
        min = avg
        max = avg + 1
    end

    local scaled
    if scalable == false then
        scaled = size
    else
        local rawScale = ScreenScale(size)
        scaled = math.Clamp(math.Round(rawScale), min, max)
    end

    local fontID = string.format('FF_Font_%s_%d_%d_%d',
                                 key, scaled,
                                 data.weight,
                                 data.extended and 1 or 0)

    if not created[fontID] then
        surface.CreateFont(fontID, {
            font     = data.fontName,
            size     = scaled,
            weight   = data.weight,
            extended = data.extended
        })
        created[fontID] = true
    end

    return fontID
end

function FFLib.Fonts:TextSize(txt, font)
    surface.SetFont(font)
    return surface.GetTextSize(txt)
end

FFLib.Fonts:Register('default', 'Museo Cyrl 500', 500, true)