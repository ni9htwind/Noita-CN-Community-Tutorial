local room_path = this_folder()

local tag_target = mod_id .. ".target"

local starting_pos = { 32, 195 }

local function reset_player_pos()
	local player_id = EntityGetWithTag( "player_unit" )[1]
	if not player_id then return end
	EntityApplyTransform( player_id, unpack( starting_pos ) )
end

local target_move_step = 60 / 60
local function move_target()
	local target_id = EntityGetWithTag( mod_id .. ".target" )[1]
	if not target_id then return end
	local x, y = EntityGetTransform( target_id )
	local direction = EntityHasTag( target_id, "down" )
	if direction then
		y = y + target_move_step
	else
		y = y - target_move_step
	end
	if y < 120 then
		EntityAddTag( target_id, "down" )
	elseif y > 220 then
		EntityRemoveTag( target_id, "down" )
	end
	EntityApplyTransform( target_id , x, y )
end

local function spawn_target()
	SetRandomSeed( GameGetFrameNum(), GameGetRealWorldTimeSinceStarted() )
	local x = Random( 108, 200 )
	local y = Random( 120, 220 )
	EntityLoad( mod_path .. "files/level_api/target.xml", x, y )
end

local time_limit = 999 * 60
local time_started = 0

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
				pos_x = 32,
				pos_y = 196,
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
			move_target()
			ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_shoot_1_1" ) )
			if #( EntityGetWithTag( tag_target ) or {} ) == 0 then
				state.stage = "shooting"
				time_started = GameGetRealWorldTimeSinceStarted()
			end
			state.kills = 0
			time_used = 0
		end,
		shooting = function( state )
			reset_player_pos()
			move_target()
			local time_now = GameGetRealWorldTimeSinceStarted()
			local time_used = time_now - time_started
			ModTextFileSetContent( const.Vfile_GuideText,
				GameTextGet( wrap_key( "guide_shoot_1_2" ), tostring( state.kills ), string.format( "%.02f", time_used ) ) )
			if #( EntityGetWithTag( tag_target ) or {} ) == 0 then
				state.kills = state.kills + 1
				if state.kills >= 15 then
					state.stage = "until_next_room"
					EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", 32, 176 )
					for i=1,5 do
						GamePrint( "本次用时：" .. string.format( "%.02f", time_used ) .. "秒" )
					end
					return
				end
				spawn_target()
			end
			if time_used >= time_limit then
				state.stage = "first"
			end
		end,
		until_next_room = function( state )
		end,
	},
}
