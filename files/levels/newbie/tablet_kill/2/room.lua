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
				pos_x = 165,
				pos_y = 135,
			},
			{
				just_load_an_entity = room_path .. "zombie_weak.xml",
				pos_x = 165,
				pos_y = 125,
			},
		},
	},
	starting_pos = { 22, 134 },
	on_loaded = function( state )
		local player_id = EntityGetWithTag( "player_unit" )[1]
		if not player_id then return end
		local wand_id = EntityLoad( "data/entities/items/starting_wand_rng.xml" )
		GamePickUpInventoryItem( player_id, wand_id, false )
		ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_tablet_kill" ) )
	end,
}
