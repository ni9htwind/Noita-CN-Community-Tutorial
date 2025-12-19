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
				pos_x = 80,
				pos_y = 137,
			},
			{
				just_load_an_entity = "data/entities/items/books/book_corpse.xml",
				pos_x = 124,
				pos_y = 137,
			},
			{
				just_load_an_entity = room_path .. "tank.xml",
				pos_x = 225,
				pos_y = 165,
			},
		},
	},
	starting_pos = { 37, 133 },
	stages = {
		start = function( state ) end,
	},
}
