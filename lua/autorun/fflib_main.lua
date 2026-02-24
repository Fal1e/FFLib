FFLib = FFLib || {}
FFLib.MainPath = 'fflib/'
FFLib.Version = '1.2.3'
/*
	FFLib - F.Fal1eLibrary
	Created by Fal1e :3
*/

// Мб до 1.1.0 дойдём :3
// ДОШЛО хАХААХАХ ;3
// Ебать ты дурак, уже на дворе 24.02.25. Уже версия 1.1.1
// 25.02.25 Уже версия 1.1.1 [S] Skin Edition
// 20.03.25 Версия 1.1.2 [SE] Skins & Experimental VGUI System
// 21.03.25 Версия уже на минуточку 1.1.3
// 21.03.25 Ну спустя пару часов, версия обновилась до 1.1.4 [TED] Test Experimental Demo
// 25.03.25 1.1.5 - Ну, ну и ну. Делать мне больно нехуй. Но на самом деле, вернул обратно методы с VGUI :happysmile:
// 16.04.25 1.1.6 - В общем, произошли обновления по цветам + по cl_webimage.lua (Добавлен метод `FFLib:WebImageShadow()`) + Fix VGUI + Added FFLib.Panel
// 07.05.25 1.1.7 [T] - Короче, проблемы. НЕ ИСПОЛЬЗОВАТЬ VGUI AVATAR. Использовать СТРОГО: FFLib:SteamAvatar()
// 14.05.25 1.1.8 [S] - Переработал либу cl_fonts.lua и добавил макс оптимизации + Обновление Scroll (отдельный скин для него)
// 15.05.25 1.1.9 [TE] - Создал новую либу sh_data.lua, добавив удобные методы для сохранения инфы в папку data
// Скоро будет эпоха версии 1.2.0 (Очень ВАЖНЫЕ изменения) //\\ XX.0X.25 1.2.0 [FS] - Версия, которая ОЧЕНЬ сильно поменяла разработку в более ЛУЧШУЮ сторону
// 31.05.25 1.2.0 [FS] - Final Stable. Версия, которая будет еще активно дорабатываться, но это то, к чему мы шли целые пол-года разработки.
// 25.09.25 1.2.1 [S] - Stable билд в котором доработаны многие недочеты + улучшены Либы
// 01.01.26 1.2.2 [S] - Stable билд, исправляющий важные ошибки и дорабатывающий оптимизацию в коде
// 11.01.26 1.2.3 - Добавлен файл sh_cooldows.lua и так-же изменены части кода на более оптимизированные версии

function FFLib:IncludeClient(path)
	if CLIENT then
		include(FFLib.MainPath .. path .. '.lua')
	end

	if SERVER then
		AddCSLuaFile(FFLib.MainPath .. path .. '.lua')
	end
end

function FFLib:IncludeServer(path)
	if SERVER then
		include(FFLib.MainPath .. path .. '.lua')
	end
end

function FFLib:IncludeShared(path)
	FFLib:IncludeServer(path)
	FFLib:IncludeClient(path)
end

FFLib:IncludeShared('settings/config')
MsgC(Color(126, 64, 174), 'F.Fal1e Library v' .. FFLib.Version)

hook.Run('FFLib.Loaded')

if SERVER then
	resource.AddWorkshop(3448842570) // Main Content
	resource.AddWorkshop(3364462345) // DarkRP Content
    concommand.Add('FFLib.ReloadLoader', function(ply)
        if ply == NULL then
            hook.Run('FFLib.Loaded')
        end
    end)
end