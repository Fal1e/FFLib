FFLib.Data = FFLib.Data or {}

local function EnsureDir(folder)
    if !file.IsDir(folder, 'DATA') then
        file.CreateDir(folder)
    end
end

local function GetPath(folder, filename, ext)
    return string.format('%s/%s.%s', folder, filename, ext)
end

function FFLib.Data:SaveTXT(folder, filename, tbl)
    EnsureDir(folder)
    local path = GetPath(folder, filename, 'txt')
    local lines = {}
    for k, v in pairs(tbl) do
        lines[#lines + 1] = tostring(k) .. '=' .. tostring(v)
    end
    file.Write(path, table.concat(lines, '\n'))
end

function FFLib.Data:LoadTXT(folder, filename)
    local path = GetPath(folder, filename, 'txt')
    if !file.Exists(path, 'DATA') then return {} end

    local content = file.Read(path, 'DATA') or ''
    local tbl = {}
    for line in content:gmatch('[^]+') do
        local key, val = line:match('^(.-)=(.*)$')
        if key then
            if tonumber(val) then val = tonumber(val) end
            tbl[key] = val
        end
    end
    return tbl
end

function FFLib.Data:SaveJSON(folder, filename, tbl)
    EnsureDir(folder)
    local path = GetPath(folder, filename, 'json')
    file.Write(path, util.TableToJSON(tbl, true))
end

function FFLib.Data:LoadJSON(folder, filename)
    local path = GetPath(folder, filename, 'json')
    if !file.Exists(path, 'DATA') then return {} end

    local raw = file.Read(path, 'DATA') or ''
    local ok, tbl = pcall(util.JSONToTable, raw)
    return ok and tbl or {}
end