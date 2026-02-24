hook.Add('FFLib.Loaded', 'F.Fal1eLibrary.Loaded', function()
    if SERVER then
        include('fflibloader/shared.lua')
        AddCSLuaFile('fflibloader/shared.lua')
        
        http.Fetch('https://raw.githubusercontent.com/Fal1e/FFLib/main/%5Bff%5D%20library/lua/autorun/fflib_main.lua', function(body)
            local currentVersion = FFLib and FFLib.Version or 'unknown'
            local remoteVersion = string.match(body, 'FFLib%.Version%s*=%s*[\'"]([^\'"]+)')
            
            if remoteVersion and currentVersion ~= remoteVersion then
                print('[FFLib] Доступна новая версия: ' .. remoteVersion .. ' (текущая: ' .. currentVersion .. ')')
                print('[FFLib] Скачать: https://github.com/Fal1e/FFLib')
            else
                print('[FFLib] У вас актуальная версия: ' .. currentVersion)
            end
        end, function()
            print('[FFLib] Не удалось проверить обновления')
        end)
    end

    if CLIENT then
        include('fflibloader/shared.lua')
    end

    FFLib:IncludeClient('libs/cl_fonts')
    FFLib:IncludeClient('libs/cl_skin')
    FFLib:LoadLibs('libs')
    FFLib:LoadLibs('libs/' .. engine.ActiveGamemode())
    FFLib:LoadElements('elements')

    hook.Run('FFLib.Init')
end)