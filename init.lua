local translations = ModTextFileGetContent( "mods/community_tutorial/translations.csv" )
local main = "data/translations/common.csv"
local main_content = ModTextFileGetContent( main )
if main_content:sub( #main_content, #main_content ) ~= "\n" then
	main_content = main_content .. "\n"
end

ModTextFileSetContent( main, main_content .. translations:gsub( "^[^\n]*\n", "", 1 ) )

dofile_once( "mods/community_tutorial/libs/DialogSystem/init.lua" )( "mods/community_tutorial/libs/DialogSystem" )

local temple_altar_scripts = {
	"data/scripts/biomes/temple_altar.lua",
	"data/scripts/biomes/temple_altar_left.lua",
	"data/scripts/biomes/temple_altar_right.lua",
	"data/scripts/biomes/temple_altar_right_snowcastle.lua",
	"data/scripts/biomes/temple_altar_right_snowcave.lua",
	"data/scripts/biomes/temple_altar_right_secret.lua",
}

for _, s in ipairs( temple_altar_scripts ) do
	ModLuaFileAppend( s, "mods/community_tutorial/files/veteran/temple_altar_append.lua" )
end
