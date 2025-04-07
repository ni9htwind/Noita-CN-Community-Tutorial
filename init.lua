local translations = ModTextFileGetContent( "mods/community_tutorial/translations.csv" )
local main = "data/translations/common.csv"
local main_content = ModTextFileGetContent( main )
if main_content:sub( #main_content, #main_content ) ~= "\n" then
	main_content = main_content .. "\n"
end
ModTextFileSetContent( main, main_content .. translations:gsub( "^[^\n]*\n", "", 1 ) )

function OnPlayerSpawned( player_id )
	local x, y = EntityGetTransform( player_id )
	EntityLoad( "mods/community_tutorial/files/veteran/entity.xml", x, y )
end

dofile_once( "mods/community_tutorial/libs/DialogSystem/init.lua" )( "mods/community_tutorial/libs/DialogSystem" )