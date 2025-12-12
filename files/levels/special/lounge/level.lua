local level_path = this_folder()
return {
	as_room = {
		starting_pos = { 640, 360 },
		biome_map = mod_path .. "files/level_api/biome_map_blank.lua",
		pixel_scenes = {
			buffered = {
				{
					material_filename = level_path .. "materials.png",
					background_filename = level_path .. "bg.png",
					pos_x = 0,
					pos_y = 0,
				},
			},
		},
	},
}
