local mod_path = "mods/community_tutorial/"

local const = dofile_once( mod_path .. "files/constants.lua" )

function polymorphing_to( entity_id )
	ModTextFileSetContent( const.Vfile_PlayerPolymorphingTo, tostring( EntitiesGetMaxID() + 1 ) )
end
