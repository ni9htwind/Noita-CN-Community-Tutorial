local translations = ModTextFileGetContent( "mods/community_tutorial/translations.csv" )
local main = "data/translations/common.csv"
local main_content = ModTextFileGetContent( main )
if main_content:sub( #main_content, #main_content ) ~= "\n" then
	main_content = main_content .. "\n"
end

ModTextFileSetContent( main, main_content .. translations:gsub( "^[^\n]*\n", "", 1 ) )

dofile_once( "mods/community_tutorial/libs/DialogSystem/init.lua" )( "mods/community_tutorial/libs/DialogSystem" )


ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua",
	"mods/community_tutorial/files/veteran/temple_altar_append.lua" )
ModLuaFileAppend( "data/scripts/biomes/mountain/mountain_left_entrance.lua",
	"mods/community_tutorial/files/veteran/mountain_left_entrance_append.lua" )
