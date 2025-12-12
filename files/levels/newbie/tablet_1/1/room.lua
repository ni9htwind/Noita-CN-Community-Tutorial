local room_path = this_folder()

local camera_movement_points = {
	{ 280, -125, 40 },
	{ 845, -125 },
	{ 1060, 90 },
	{ 1466, 573 },
	{ 2335, 845, 40 },
	{ 2160, 840 },
}

local smoothe_coeff = 20

local step_length = 6

local poof = dofile_once( mod_path .. "libs/poof/main.lua" )

local function vec_clone( vec )
	return { vec[1], vec[2] }
end

local function vec_add( vec1, vec2 )
	return { vec1[1] + vec2[1], vec1[2] + vec2[2] }
end

local function vec_sub( vec1, vec2 )
	return { vec1[1] - vec2[1], vec1[2] - vec2[2] }
end

local function vec_mult( vec, a )
	return { vec[1] * a, vec[2] * a }
end

local function vec_len2( vec )
	return vec[1] ^ 2 + vec[2] ^ 2
end

local function vec_len( vec )
	return math.sqrt( vec_len2( vec ) )
end

local function vec_normalize( vec )
	if vec[1] == 0 and vec[2] == 0 then
		return {0,0}
	end

	local len = vec_len( vec )
	return { vec[1] / len, vec[2] / len }
end

local function vec_distance( vec1, vec2 )
	return vec_len( vec_sub( vec1, vec2 ) )
end

local name_hidden_player = mod_id .. ".hidden_player"

return {
	starting_pos = vec_clone( camera_movement_points[1] ),
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
	stages = {
		start = {
			update = function( state )
				local player_id = EntityGetWithTag( "player_unit" )[1]
				if not player_id then return end
				
				state.next_point_index = 1
				
				poof.hide( player_id, name_hidden_player )
				
				state.stage = "camera_movement"
				
				local world_state = GameGetWorldStateEntity()
				world_state = EntityGetFirstComponentIncludingDisabled( world_state, "WorldStateComponent" )
				ComponentSetValue2( world_state, "open_fog_of_war_everywhere", true )
			end,
		},
		camera_movement = {
			update = function( state )
				local pos = { GameGetCameraPos() }
				local next_point = camera_movement_points[ state.next_point_index ]
				if not next_point then
					state.stage = "camera_movement_end"
					return
				end
				
				local _step_length = step_length
				
				local distance_left = vec_distance( pos, next_point )
				if next_point[3] and distance_left <= step_length * smoothe_coeff then
					_step_length = math.min( _step_length, math.max( distance_left / smoothe_coeff, 0.1 ) )
				end
				
				local last_point = camera_movement_points[ state.next_point_index - 1 ]
				if last_point then
					local distance_traveled = vec_distance( last_point, pos )
					if last_point[3] and distance_traveled <= step_length * smoothe_coeff then
						_step_length = math.min( _step_length, math.max( distance_left / smoothe_coeff, 0.1 ) )
					end
				end
				
				if state.next_point_index > 1 and distance_left >= _step_length then
					pos = vec_add( pos, vec_mult( vec_normalize( vec_sub( next_point, pos ) ), _step_length ) )
				else
					pos = vec_clone( next_point )
					
					if next_point[3] then
						state.time_stayed = ( state.time_stayed or 0 ) + 1
						if state.time_stayed <= next_point[3] then
							return
						else
							state.time_stayed = 0
						end
					end
					
					state.next_point_index = state.next_point_index + 1
				end
				
				local player_id = EntityGetWithName( name_hidden_player )
				EntitySetTransform( player_id, unpack( pos ) )
				GameSetCameraPos( unpack( pos ) )
			end,
		},
		camera_movement_end = {
			update = function( state )
				poof.unpolymorph( EntityGetWithName( name_hidden_player ) )
				
				local world_state = GameGetWorldStateEntity()
				world_state = EntityGetFirstComponentIncludingDisabled( world_state, "WorldStateComponent" )
				ComponentSetValue2( world_state, "open_fog_of_war_everywhere", false )
				
				state.stage = "fetch_tablet"
			end,
		},
		fetch_tablet = {
			update = function( state )
				for _, tablet_id in ipairs( EntityGetWithTag( "tablet" ) or {} ) do
					if EntityHasTag( EntityGetRootEntity( tablet_id ), "player_unit" ) then
						EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", 2335, 787 )
						state.stage = "until_next_room"
					end
				end
			end,
		},
		until_next_room = {
			update = function( state ) end,
		},
	},
}