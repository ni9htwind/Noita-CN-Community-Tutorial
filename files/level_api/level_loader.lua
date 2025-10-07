local mod_path = "mods/community_tutorial/"
local const = dofile_once( mod_path .. "files/constants.lua" )

-- dofile_once( "data/scripts/perks/perk.lua" )

local pixel_scene_file_content = [[
<PixelScenes>
	<mBufferedPixelScenes>
		<PixelScene
			background_filename=""
			material_filename="%s"
			colors_filename="%s"
			pos_x="0"
			pos_y="0"
			skip_biome_checks="1">
		</PixelScene>
	</mBufferedPixelScenes>
</PixelScenes>
]]

local level_loader = {}

function level_loader.load( level )
	local level_path = level.path

	local player_id = EntityGetWithTag( "player_unit" )[1]

	for _, comp_id in ipairs( EntityGetAllComponents( player_id ) ) do
		EntityRemoveComponent( player_id, comp_id )
	end
	EntityLoadToEntity( "data/entities/player_base.xml", player_id )

	for _, child_id in ipairs( EntityGetAllChildren( player_id ) ) do
		EntityRemoveFromParent( child_id )
		EntityKill( child_id )
	end
	EntityAddChild( player_id, EntityCreateNew( "inventory_quick" ) )
	EntityAddChild( player_id, EntityCreateNew( "inventory_full" ) )

	local materials_file = level_path .. "materials.png"
	local colors_file = level_path .. "colors.png"

	local pixel_scene_file = level_path .. "pixel_scene.xml"
	if not ModDoesFileExist( pixel_scene_file ) then
		ModTextFileSetContent_Saved( pixel_scene_file, pixel_scene_file_content:format( materials_file, colors_file ) )
	end

	BiomeMapLoad_KeepPlayer( mod_path .. "files/level_api/biome_blank/biome_map_blank.lua",
		-- mod_path .. "files/level_api/biome_blank/_pixel_scenes_blank.xml" )
		pixel_scene_file )

	-- LoadPixelScene( materials_file, colors_file, 0, 0, "", true, true )

	GlobalsSetValue( const.Globals_CurrentLevel, level.id )

	EntitySetTransform( player_id, level.starting_pos_x, level.starting_pos_y )

	-- EntityLoad( "data/entities/particles/supernova.xml", 0, 0 )
end

return level_loader