local mod_path = "mods/community_tutorial/"
local const = dofile_once( mod_path .. "files/constants.lua" )

function collision_trigger( colliding_entity_id )
	ModTextFileSetContent( const.Vfile_EnterNextRoom, "1" )
end
