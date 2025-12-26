local room_path = this_folder()

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
				pos_x = 36,
				pos_y = 67,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/end_point/base.xml",
				pos_x = 356,
				pos_y = 60,
			},
		},
	},
	starting_pos = { 36, 48 },
	on_loaded = function( state )
		EntityAddComponent2( EntityGetWithTag( "player_unit" )[1], "LuaComponent", {
			script_damage_received = room_path .. "teleport_on_hurt.lua",
		} )
		ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_hover_1_1" ) )
	end,
}
