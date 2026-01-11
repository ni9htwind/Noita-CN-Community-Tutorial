local room_path = this_folder()

local tag_target = mod_id .. ".target"

local starting_pos = { 300, 386 }

local function reset_player_pos()
	local player_id = EntityGetWithTag( "player_unit" )[1]
	if not player_id then return end
	EntityApplyTransform( player_id, unpack( starting_pos ) )
end

local function spawn_target()
	SetRandomSeed( GameGetFrameNum(), GameGetRealWorldTimeSinceStarted() )
	local center_x, center_y = unpack( starting_pos )
	local angle = Randomf( math.pi )
	local dist = Randomf( 50, 100 )
	local x = center_x + dist * math.cos( angle )
	local y = center_y - dist * math.sin( angle ) - 20
	EntityLoad( room_path .. "target.xml", x, y )
end

local time_limit = 999 * 60
local time_used = 0

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
				pos_x = 300,
				pos_y = 387,
			},
		},
	},
	starting_pos = starting_pos,
	on_loaded = function( state )
		spawn_target()
		local player_id = EntityGetWithTag( "player_unit" )[1]
		if not player_id then return end
		local wand_id = EntityLoad( "data/entities/items/starting_wand.xml", unpack( starting_pos ) )
		GamePickUpInventoryItem( player_id, wand_id, false )
	end,
	stages = {
		first = function( state )
			reset_player_pos()
			ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_shoot_1_1" ) )
			if #( EntityGetWithTag( tag_target ) or {} ) == 0 then
				state.stage = "shooting"
			end
			state.kills = 0
			time_used = 0
		end,
		shooting = function( state )
			reset_player_pos()
			ModTextFileSetContent( const.Vfile_GuideText,
				GameTextGet( wrap_key( "guide_shoot_1_2" ), tostring( state.kills ), string.format( "%.02f", time_used / 60 ) ) )
			if #( EntityGetWithTag( tag_target ) or {} ) == 0 then
				state.kills = state.kills + 1
				if state.kills >= 15 then
					state.stage = "until_next_room"
					EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", 300, 360 )
					for i=1,5 do
						GamePrint( "本次用时：" .. string.format( "%.02f", time_used / 60 ) .. "秒" )
					end
					return
				end
				spawn_target()
			end
			time_used = time_used + 1
			if time_used >= time_limit then
				state.stage = "first"
			end
		end,
		until_next_room = function( state )
		end,
	},
}
