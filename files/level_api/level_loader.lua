local mod_path = "mods/community_tutorial/"
local Globals_CurrentLevel = "COMMUNITY_TUTORIAL.LEVEL"

dofile_once( "data/scripts/perks/perk.lua" )
dofile_once( mod_path .. "scripts/tutorial/levels_info.lua" )

function load_level( level_path )
	local player_id = 0
	for _, e in ipairs( EntityGetInRadius( 0, 0, math.huge ) or {} ) do
		if EntityHasTag( entity, "player_unit" ) then
			player_id = e
		else
			EntityKill( entity )
		end
	end

	for _, comp_id in ipairs( EntityGetAllComponents( player_id ) ) do
		EntityRemoveComponent( player_id, comp_id )
	end
	EntityLoadToEntity( "data/entities/player_base.xml", c )

	for _, child_id in ipairs( EntityGetAllChildren( player_id ) ) do
		EntityRemoveFromParent( child_id )
		EntityKill( child_id )
	end
	EntityAddChild( player_id, EntityCreateNew( "inventory_quick" ) )
	EntityAddChild( player_id, EntityCreateNew( "inventory_full" ) )

	BiomeMapLoad_KeepPlayer( mod_path .. "files/level_api/biome/biome_map_tutorial.lua",
		mod_path .. "files/level_api/biome_blank/_pixel_scenes_blank.xml" )

	local level_info = dofile_once( level_path .. "info.lua" )

	GlobalsSetValue( Globals_CurrentLevel, level_info.id )

	local materials_file = level_path .. "materials.png"
	local colors_file = level_path .. "colors.png"
	LoadPixelScene( materials_file, colors_file, 0, 0, "", true, true )

	EntitySetTransform( player_id, level_info.starting_pos_x, level_info.starting_pos_y )

	EntityLoad( "data/entities/particles/supernova.xml", 0, 0 )
end
