local mod_path = "mods/community_tutorial/"
local const = dofile_once( mod_path .. "files/constants.lua" )

local pixel_scene_file_content =
[[<PixelScenes>
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

local biome_map_blank = mod_path .. "files/level_api/biome_map_blank.lua"

local level_loader = {}

function level_loader.load( level, room_index )
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

	local room = level.rooms[ room_index ]

	local pixel_scene_file = ("%sroom_%d_pixel_scene.xml"):format( level.path, room_index )
	if not ModDoesFileExist( pixel_scene_file ) then
		ModTextFileSetContent_Saved( pixel_scene_file, pixel_scene_file_content:format( unpack( room.pixel_scene ) ) )
	end

	BiomeMapLoad_KeepPlayer( biome_map_blank, pixel_scene_file )

	EntitySetTransform( player_id, room.starting_pos_x or 0, room.starting_pos_y or 0 )

	GlobalsSetValue( const.Globals_CurrentLevel, level.id )
	GlobalsSetValue( const.Globals_CurrentRoomIndex, room_index )

	-- EntityLoad( "data/entities/particles/supernova.xml", 0, 0 )
end

return level_loader