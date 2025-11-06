local camera_movement_points = {
	{ 280, -125 },
	{ 845, -125 },
	{ 1060, 90 },
	{ 1060, 840 },
	{ 2160, 840 },
}

local step_length = 6

local poof = dofile_once( mod_path .. "libs/poof/main.lua" )
poof.ModTextFileSetContent = ModTextFileSetContent_Saved

local function vec_add( x1, y1, x2, y2 )
	return x1 + x2, y1 + y2
end

local function vec_mult( x, y, a )
	return x * a, y * a
end

local function vec_len2( x, y )
	return x ^ 2 + y ^ 2
end

local function vec_normalize( x, y )
	local len2 = vec_len2( x, y )
	if len2 == 0 then
		return 0,0
	else
		local len = math.sqrt( len2 )
		return x / len, y / len
	end
end

local name_hidden_player = mod_id .. ".hidden_player"

return {
	as_room = {
		biome_map = "data/scripts/biome_map.lua",
		pixel_scenes = {
			files = { "data/biome/_pixel_scenes.xml" },
			buffered = {
				{
					material_filename = level_path .. "invisible_wall_left.png",
					pos_x = 2032,
					pos_y = 720,
					skip_edge_textures = true,
				},
				{
					material_filename = level_path .. "invisible_wall_left.png",
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

					poof.hide( player_id, name_hidden_player )

					state.next_point_index = 1

					state.stage = "camera_movement"

					local world_state = GameGetWorldStateEntity()
					world_state = EntityGetFirstComponentIncludingDisabled( world_state, "WorldStateComponent" )
					ComponentSetValue2( world_state, "open_fog_of_war_everywhere", true )
				end,
			},
			camera_movement = {
				update = function( state )
					local x, y = GameGetCameraPos()
					local next_point_x, next_point_y = unpack( camera_movement_points[ state.next_point_index ] )

					if vec_len2( x - next_point_x, y - next_point_y ) < step_length ^ 2 then
						state.next_point_index = state.next_point_index + 1
						local next_point = camera_movement_points[ state.next_point_index ]
						if next_point then
							next_point_x, next_point_y = unpack( next_point )
						else
							state.stage = "camera_movement_end"
							return
						end
					end

					local temp_x, temp_y = vec_normalize( vec_add( -x, -y, next_point_x, next_point_y ) )
					x, y = vec_add( x, y, vec_mult( temp_x, temp_y, step_length ) )

					local player_id = EntityGetWithName( name_hidden_player )
					EntitySetTransform( player_id, x, y )
					GameSetCameraPos( x, y )
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
							state.finished = true
						end
					end
				end,
			},
		},
	},
}