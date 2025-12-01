local mod_path = "mods/community_tutorial/"

local const = dofile_once( mod_path .. "files/constants.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal )
	if not is_fatal then return end
	GlobalsSetValue( const.Globals_RestartRoom, "1" )
end
