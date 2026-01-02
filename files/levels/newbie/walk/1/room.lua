local room_path = this_folder()

local time_used = 0
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
		time_used = 0
	end,
	stages = {
		first = function( state )
			time_used = time_used + 1
			local guide_text = GameTextGet( wrap_key( "guide_walk_1" ), string.format( "%.02f", time_used / 60 ) )
			ModTextFileSetContent( const.Vfile_GuideText, guide_text )
		end,
	},
}
