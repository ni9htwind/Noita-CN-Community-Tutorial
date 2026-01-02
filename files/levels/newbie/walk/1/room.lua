local room_path = this_folder()

local var = dofile_once( mod_path .. "libs/var.lua" )

local x_to_stage = {
	{ 48, "first" },
	{ 560, "cave" },
	{ math.huge, "end_point" },
}

local function get_stage( x )
	for _, pair in pairs( x_to_stage ) do
		local limit_x, stage = pair[1], pair[2]
		if x <= limit_x then
			return stage
		end
	end
end

local time_limit = 25 * 60

return {
	pixel_scenes = {
		buffered = {
			{
				material_filename = room_path .. "materials.png",
				pos_x = 0,
				pos_y = 0,
			},
			{
				just_load_an_entity = room_path .. "sign.xml",
				pos_x = 29,
				pos_y = 121,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/end_point/base.xml",
				pos_x = 575,
				pos_y = 101,
			},
		},
	},
	starting_pos = { 29, 123 },
	on_loaded = function( state )
		local player_id = EntityGetWithTag( "player_unit" )[1]
		EntityAddComponent2( player_id, "LuaComponent", {
			script_damage_received = room_path .. "player_hurt.lua",
		} )
		EntitySetDamageFromMaterial( player_id, "peat", 0.0001 )

		local world_state = GameGetWorldStateEntity()
		world_state = EntityGetFirstComponentIncludingDisabled( world_state, "WorldStateComponent" )
		ComponentSetValue2( world_state, "open_fog_of_war_everywhere", true )
	end,
	stages = {
		first = function( state )
			local vars_entity = EntityGetWithName( const.EntityName_LevelVars )
			var.write( vars_entity, "time_used", "value_int", 0 )
			ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_walk_1_1" ) )

			local x = EntityGetTransform( EntityGetWithTag( "player_unit" )[1] )
			state.stage = get_stage( x )
		end,
		cave = function( state )
			local vars_entity = EntityGetWithName( const.EntityName_LevelVars )
			local time_used = var.update( vars_entity, "time_used", "value_int", function( i ) return i + 1 end, 0 )

			if time_used >= time_limit then
				EntitySetTransform( EntityGetWithTag( "player_unit" )[1], 29, 123 )
				var.write( vars_entity, "time_used", "value_int", 0 )
				state.stage = "first"
				return
			end

			local guide_text = GameTextGet( wrap_key( "guide_walk_1_2" ), string.format( "%.02f", time_used / 60 ) )
			ModTextFileSetContent( const.Vfile_GuideText, guide_text )

			local x = EntityGetTransform( EntityGetWithTag( "player_unit" )[1] )
			state.stage = get_stage( x )
		end,
		end_point = function( state ) end,
	},
}
