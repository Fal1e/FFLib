function FFLib:LoadLibs(directory)
    local files, directories = file.Find(FFLib.MainPath .. directory .. '/*', 'LUA')

    for _, dir in ipairs(directories) do
        FFLib:LoadLibs(directory .. '/' .. dir)
    end

    for _, file in ipairs(files) do
        local path = FFLib.MainPath .. directory .. '/' .. file
        if string.StartWith(file, 'sh_') then
            if SERVER then
                AddCSLuaFile(path)
            end
            include(path)
            MsgC(Color(0, 0, 255), '\n[Libs | SH] Loaded File: ' .. file)
        end
    end

    for _, file in ipairs(files) do
        local path = FFLib.MainPath .. directory .. '/' .. file
        if string.StartWith(file, 'cl_') then
            if CLIENT then
                include(path)
            else
                AddCSLuaFile(path)
            end
            MsgC(Color(255, 0, 0), '\n[Libs | CL] Loaded File: ' .. file)
        end
    end

    for _, file in ipairs(files) do
        local path = FFLib.MainPath .. directory .. '/' .. file
        if string.StartWith(file, 'sv_') then
            if SERVER then
                include(path)
            end
            MsgC(Color(0, 255, 0), '\n[Libs | SV] Loaded File: ' .. file)
        end
    end
end

function FFLib:LoadElements(directory)
    local files, directories = file.Find(FFLib.MainPath .. directory ..'/*', 'LUA')
        
    for _, dir in ipairs(directories) do
        FFLib:LoadElements(FFLib.MainPath .. directory ..'/' .. dir)
    end

    for _, file in ipairs(files) do
        local path = FFLib.MainPath .. directory ..'/' .. file

        if CLIENT then
            include(path)
        else
            AddCSLuaFile(path)
        end
        MsgC(Color(255, 0, 0), '\n[Elements] Include File: ' .. file .. '\n')
    end
end