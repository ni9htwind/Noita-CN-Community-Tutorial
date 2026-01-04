local level_path = this_folder()
return {
	as_room = {
		starting_pos = { 640, 360 },
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
