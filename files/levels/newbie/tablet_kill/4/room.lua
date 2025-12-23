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
				pos_x = 78,
				pos_y = 66,
			},
			{
				just_load_an_entity = "data/entities/items/books/book_corpse.xml",
				pos_x = 103,
				pos_y = 62,
			},
			{
				just_load_an_entity = room_path .. "slimeshooter.xml",
				pos_x = 120,
				pos_y = 105,
			},
		},
	},
	starting_pos = { 37, 133 },
	stages = {
		start = function( state )
			state.stage = "until_next_room"
			ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_tablet_kill" ) )
		end,
		until_next_room = function( state ) end,
	},
}
