local room_path = this_folder()

local poof = dofile_once( mod_path .. "libs/poof/main.lua" )
local whoosh = dofile( mod_path .. "libs/whoosh.lua" )

local whoosh_points = {
	{ 280, -125, 40 },
	{ 845, -125 },
	{ 1060, 90 },
	{ 1466, 573 },
	{ 2335, 845, 40 },
	{ 2160, 840 },
}

local name_hidden_player = mod_id .. ".hidden_player"

return {
	biome_map = "data/scripts/biome_map.lua",
	pixel_scenes = {
		files = { "data/biome/_pixel_scenes.xml" },
		buffered = {
			{
				material_filename = room_path .. "invisible_wall_left.png",
				pos_x = 2048,
				pos_y = 720,
				skip_edge_textures = true,
			},
			{
				material_filename = room_path .. "invisible_wall_left.png",
				pos_x = 2416,
				pos_y = 624,
				skip_edge_textures = true,
			},
		},
	},
	starting_pos = { whoosh_points[1][1], whoosh_points[1][2] },
	stages = {
		start = function( state )
			local player_id = EntityGetWithTag( "player_unit" )[1]
			if not player_id then return end

			whoosh:init( whoosh_points, 6, 20 )

			poof.hide( player_id, name_hidden_player )

			state.stage = "camera_movement"

			local world_state = GameGetWorldStateEntity()
			world_state = EntityGetFirstComponentIncludingDisabled( world_state, "WorldStateComponent" )
			ComponentSetValue2( world_state, "open_fog_of_war_everywhere", true )
		end,
		camera_movement = function( state )
			if whoosh:update() then
				local player_id = EntityGetWithName( name_hidden_player )
				EntitySetTransform( player_id, GameGetCameraPos() )
			else
				state.stage = "camera_movement_end"
			end
		end,
		camera_movement_end = function( state )
			poof.unpolymorph( EntityGetWithName( name_hidden_player ) )

			local world_state = GameGetWorldStateEntity()
			world_state = EntityGetFirstComponentIncludingDisabled( world_state, "WorldStateComponent" )
			ComponentSetValue2( world_state, "open_fog_of_war_everywhere", false )

			state.stage = "fetch_tablet"
		end,
		fetch_tablet = function( state )
			for _, tablet_id in ipairs( EntityGetWithTag( "tablet" ) or {} ) do
				if EntityHasTag( EntityGetRootEntity( tablet_id ), "player_unit" ) then
					EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", 2335, 787 )
					state.stage = "until_next_room"
				end
			end
		end,
		until_next_room = function( state ) end,
	},
}
