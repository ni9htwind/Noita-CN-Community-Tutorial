local room_path = this_folder()

local vec2 = dofile_once( mod_path .. "libs/vec2.lua" )

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
				pos_x = 19,
				pos_y = 187,
			},
			-- {
			-- 	just_load_an_entity = mod_path .. "files/level_api/portal_next_room/entity.xml",
			-- 	pos_x = 520,
			-- 	pos_y = 169,
			-- },
		},
	},
	starting_pos = { 19, 178 },
	stages = {
		start = function( state )
			EntityAddComponent2( EntityGetWithTag( "player_unit" )[1], "LuaComponent", {
				script_damage_received = room_path .. "teleport_on_hurt.lua",
			} )
			state.stage = "until_next_room"
			ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_hover_1_1" ) )
		end,
		portal_check = function( state )
			local player_id = EntityGetWithTag( "player_unit" )[1]
			if not player_id then return end

			local x, y = 520, 169
			local px, py = EntityGetTransform( player_id )
			if vec2.distance( { x, y }, { px, py } ) < 16 * 16 then
				EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", x, y )
				state.stage = "until_next_room"
			end
		end,
		until_next_room = function( state ) end,
	},
}