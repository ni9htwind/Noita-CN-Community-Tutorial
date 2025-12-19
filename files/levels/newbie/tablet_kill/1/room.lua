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
				just_load_an_entity = room_path .. "sign_a.xml",
				pos_x = 137,
				pos_y = 287,
			},
			{
				just_load_an_entity = room_path .. "sign_b.xml",
				pos_x = 186,
				pos_y = 265,
			},
			{
				just_load_an_entity = "data/entities/items/books/book_corpse.xml",
				pos_x = 224,
				pos_y = 257,
			},
			{
				just_load_an_entity = room_path .. "zombie.xml",
				pos_x = 330,
				pos_y = 287,
			},
		},
	},
	starting_pos = { 100, 286 },
	stages = {
		start = function( state ) end,
	},
}
