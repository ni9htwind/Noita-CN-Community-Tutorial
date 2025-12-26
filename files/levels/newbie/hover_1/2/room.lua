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
				pos_x = 32,
				pos_y = 78,
			},
			{
				just_load_an_entity = mod_path .. "files/level_api/end_point/base.xml",
				pos_x = 496,
				pos_y = 64,
			},
		},
	},
	starting_pos = { 24, 75 },
	stages = {
		start = function( state )
			state.stage = "fall_check"
			ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_hover_1_2" ) )
		end,
		fall_check = function( state )
			local player_id = EntityGetWithTag( "player_unit" )[1]
			if not player_id then return end
			
			local x, y = EntityGetTransform( player_id )
			if y > 150 then
				EntitySetTransform( player_id, 24, 75 )
			end
		end,
	},
}