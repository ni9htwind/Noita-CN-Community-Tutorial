local mod_path = "mods/community_tutorial/"

local const = dofile_once( mod_path .. "files/constants.lua" )
local var = dofile_once( mod_path .. "libs/var.lua" )

local teleport_to = { 29, 123 }

function damage_received( ... )
	EntitySetTransform( GetUpdatedEntityID(), unpack( teleport_to ) )

	local vars_entity = EntityGetWithName( const.EntityName_LevelVars )
	var.write( vars_entity, "time_used", "value_int", 0 )
end
