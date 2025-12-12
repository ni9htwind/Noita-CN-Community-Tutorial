local mod_path = "mods/community_tutorial/"
local room_path = this_folder()

return {
	starting_pos = { 300, 185 },
	biome_map = mod_path .. "files/level_api/biome_map_blank.lua",
	pixel_scenes = {
		buffered = {
			{
				material_filename = room_path .. "materials.png",
				-- background_filename = room_path .. "bg.png",
				pos_x = 0,
				pos_y = 0,
			},
			{
				just_load_an_entity = mod_path .. "files/veteran/entity.xml",
				pos_x = 200,
				pos_y = 186,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/dummy_target/entity.xml",
				pos_x = 150,
				pos_y = 170,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/dummy_target/entity.xml",
				pos_x = 120,
				pos_y = 170,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/dummy_target/entity.xml",
				pos_x = 90,
				pos_y = 170,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/dummy_target/entity.xml",
				pos_x = 360,
				pos_y = 130,
			},
		},
	},
	stages = {
		start = {
			update = function( state )
				local player_id = EntityGetWithTag( "player_unit" )[1]
				if not player_id then return end

				local x, y = EntityGetTransform( player_id )
				local tablet_id = EntityLoad( "data/entities/items/books/book_corpse.xml", x, y )
				GamePickUpInventoryItem( player_id, tablet_id )

				state.stage = "todo"
			end,
		},
		todo = {
			update = function( state )
			end,
		},
	},
}
