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
				pos_x = 42,
				pos_y = 138,
			},
			{
				just_load_an_entity = "data/entities/items/books/book_corpse.xml",
				pos_x = 161,
				pos_y = 132,
			},
			{
				just_load_an_entity = room_path .. "zombie.xml",
				pos_x = 171,
				pos_y = 132,
			},
		},
	},
	starting_pos = { 22, 134 },
	on_loaded = function( state )
		ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_tablet_kill" ) )
	end,
}
