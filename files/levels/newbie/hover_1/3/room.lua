local room_path = this_folder()

return {
	biome_map = mod_path .. "files/level_api/biome_map_blank.lua",
	pixel_scenes = {
		buffered = {
			{
				material_filename = room_path .. "materials.png",
				pos_x = 0,
				pos_y = 0,
			},
			{
				just_load_an_entity = room_path .. "sign.xml",
				pos_x = 34,
				pos_y = 319,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/end_point/base.xml",
				pos_x = 70,
				pos_y = 56,
			},
		},
	},
	starting_pos = { 34, 308 },
	stages = {
		start = function( state )
			state.stage = "until_next_room"
			ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_hover_1_3" ) )
		end,
		until_next_room = function( state ) end,
	},
}