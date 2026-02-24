local path = string.gsub(FFLib.MainPath, '/', '')

file.CreateDir(path)
local exists = file.Exists
local write = file.Write
local fetch = http.Fetch
local white = Color(255, 255, 255)
local surface = surface
local crc = util.CRC
local _error = Material('fflib/dev/load_image.png', 'noclamp smooth')
local math = math
local mats = {}
local fetchedavatars = {}

function fetch_asset(url)
    if !url then return _error end
    if mats[url] then return mats[url] end
    local crc = crc(url)

    if exists(path ..'/' .. crc .. '.png', 'DATA') then
        mats[url] = Material('data/' .. path .. '/' .. crc .. '.png', 'smooth')

        return mats[url]
    end

    mats[url] = _error

    fetch(url, function(data)
        write(path ..'/' .. crc .. '.png', data)
        mats[url] = Material('data/' .. path .. '/' .. crc .. '.png', 'smooth')
    end)

    return mats[url]
end

function fetch_asset_name(url, name)
    if !url then return _error end
    if mats[url] then return mats[url] end
    local crc = name

    if exists(path ..'/' .. crc .. '.png', 'DATA') then
        mats[url] = Material('data/'..path..'/' .. crc .. '.png', 'noclamp smooth')

        return mats[url]
    end

    mats[url] = _error

    fetch(url, function(data)
        write(path ..'/' .. crc .. '.png', data)
        mats[url] = Material('data/' .. path .. '/' .. crc .. '.png', 'noclamp smooth')
    end)

    return mats[url]
end

function fetchAvatarAsset(id64, size)
    id64 = id64 or 'BOT'
    size = size == 'medium' and 'medium' or size == 'small' and '' or size == 'large' and 'full' or ''
    local key = id64 .. ' ' .. size

    if fetchedavatars[key] then return fetchedavatars[key] end

    if id64 == 'BOT' then
        fetchedavatars[key] = 'http://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/09/09962d76e5bd5b91a94ee76b07518ac6e240057a_full.jpg'
        return fetchedavatars[key]
    end

    fetch('http://steamcommunity.com/profiles/' .. id64 .. '/?xml=1', function(body)
        local link = body:match('<avatarFull><!%[CDATA%[(.-)]]></avatarFull>')
        if !link then
            fetchedavatars[key] = 'http://i.imgur.com/uaYpdq7.png'
            return
        end
    
        fetchedavatars[key] = link
    end)

    return nil
end

function FFLib:WebImage(url, x, y, width, height, color, angle, cornerorigin)
    color = color or white

    surface.SetDrawColor(color.r, color.g, color.b, color.a)
    surface.SetMaterial(fetch_asset(url))

    if !angle then
        surface.DrawTexturedRect(x, y, width, height)
    else
        if !cornerorigin then
            surface.DrawTexturedRectRotated(x, y, width, height, angle)
        else
            surface.DrawTexturedRectRotated(x + width / 2, y + height / 2, width, height, angle)
        end
    end
end

function FFLib:WebImageShadow(url, x, y, width, height, color, shadowOffset, shadowColor, angle, cornerorigin)
	color = color or white
	shadowOffset = shadowOffset or 4
	shadowColor = shadowColor or Color(0, 0, 0, 50)

	local mat = fetch_asset(url)

	surface.SetMaterial(mat)
	surface.SetDrawColor(shadowColor.r, shadowColor.g, shadowColor.b, shadowColor.a)

	if !angle then
		surface.DrawTexturedRect(x + shadowOffset, y + shadowOffset, width, height)
	else
		if !cornerorigin then
			surface.DrawTexturedRectRotated(x + shadowOffset, y + shadowOffset, width, height, angle)
		else
			surface.DrawTexturedRectRotated(x + width / 2 + shadowOffset, y + height / 2 + shadowOffset, width, height, angle)
		end
	end

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(mat)

	if !angle then
		surface.DrawTexturedRect(x, y, width, height)
	else
		if !cornerorigin then
			surface.DrawTexturedRectRotated(x, y, width, height, angle)
		else
			surface.DrawTexturedRectRotated(x + width / 2, y + height / 2, width, height, angle)
		end
	end
end

function FFLib:RotateWebImageShadow(matURL, x, y, w, h, col, sShadow, colShadow, speed, origin)
	FFLib:WebImageShadow((matURL or 'https://www.iconsdb.com/icons/preview/white/circle-dashed-6-xxl.png'), x, y, w, h, col, sShadow, colShadow, ((ct or CurTime()) % 360) * (speed or -100), origin)
end

function FFLib:RotateWebImage(matURL, x, y, w, h, col, speed, origin)
	FFLib:WebImage((matURL or 'https://www.iconsdb.com/icons/preview/white/circle-dashed-6-xxl.png'), x, y, w, h, col, ((ct or CurTime()) % 360) * (speed or -100), origin)
end

function FFLib:SeamlessWebImage(url, parentwidth, parentheight, xrep, yrep, color)
    color = color or white
    local xiwx, yihy = math.ceil(parentwidth / xrep), math.ceil(parentheight / yrep)

    for x = 0, xrep - 1 do
        for y = 0, yrep - 1 do
            FFLib:WebImage(url, x * xiwx, y * yihy, xiwx, yihy, color)
        end
    end
end

function FFLib:SteamAvatar(avatar, res, x, y, width, height, color, ang, corner)
    FFLib:WebImage(fetchAvatarAsset(avatar, res), x, y, width, height, color, ang, corner)
end