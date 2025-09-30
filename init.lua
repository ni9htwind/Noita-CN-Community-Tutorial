local mod_path = "mods/community_tutorial/"

local translations = ModTextFileGetContent( mod_path .. "translations.csv" )
local main = "data/translations/common.csv"
local main_content = ModTextFileGetContent( main )
if main_content:sub( #main_content, #main_content ) ~= "\n" then
	main_content = main_content .. "\n"
end

ModTextFileSetContent( main, main_content .. translations:gsub( "^[^\n]*\n", "", 1 ) )

dofile_once( mod_path .. "libs/DialogSystem/init.lua" )( mod_path .. "libs/DialogSystem" )

ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua",
	mod_path .. "files/veteran/temple_altar_append.lua" )
ModLuaFileAppend( "data/scripts/biomes/mountain/mountain_left_entrance.lua",
	mod_path .. "files/veteran/mountain_left_entrance_append.lua" )

dofile_once( mod_path .. "libs/polytools_init.lua" ).init( mod_path .. "libs/" )