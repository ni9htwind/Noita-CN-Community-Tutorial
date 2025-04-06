local translations = ModTextFileGetContent( "mods/community_tutorial/translations.csv" )
local main = "data/translations/common.csv"
local main_content = ModTextFileGetContent( main )
if main_content:sub( #main_content, #main_content ) ~= "\n" then
	main_content = main_content .. "\n"
end
ModTextFileSetContent( main, main_content .. translations:gsub( "^[^\n]*\n", "", 1 ) )

local tips_gui = dofile_once( "mods/community_tutorial/files/tips/gui.lua" )

local death_tip_func
function OnWorldPreUpdate()
	if #EntityGetWithTag( "player_unit" ) == 0 and #EntityGetWithTag( "polymorphed_player" ) == 0 then
		death_tip_func = death_tip_func or tips_gui.generate_random_tip_func( 1 / 2,  8 / 9, GameGetCameraPos() )
		death_tip_func()
	end
end