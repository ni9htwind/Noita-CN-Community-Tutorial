local mod_path = "mods/community_tutorial/"

local dialog_system = dofile_once( mod_path .. "libs/DialogSystem/dialog_system.lua" )
if not whoosh then
	whoosh = dofile_once( mod_path .. "libs/whoosh.lua" )
	local x, y = GameGetCameraPos()
	whoosh.pos_getter = function()
		return { x, y }
	end
	whoosh.pos_setter = function( pos )
		x, y = unpack( pos ) 
		GameSetCameraFree( false )
		GameSetCameraPos( x, y )
		GameSetCameraFree( true )
	end
end

dofile_once( mod_path .. "files/misc_utils.lua" )

local room_path = this_folder()

local level_id = "tablet_1"
local room_index = 2
function dialog_line( index )
	return get_text( ("dialog_%s_%d_%d"):format( level_id, room_index, index ) )
end

local entity_id = GetUpdatedEntityID()

local ln_comp = EntityGetComponent( entity_id, "VariableStorageComponent" )[1]
local line_num = ComponentGetValue2( ln_comp, "value_int" )

local option_continue = {
	text = get_text( "dialog_option_continue" ),
	func = function( dialog )
		line_num = line_num + 1
		dialog.show( dialog_lines[ line_num ] )
	end,
}

if not dialog_lines then
	local function load_tablet( x, y )
		EntityLoad( "data/entities/items/books/book_corpse.xml", x, y )
		EntityLoad( room_path .. "tablet_marker.xml", x, y )
	end

	dialog_lines = {
		{
			text = dialog_line(1),
			options = { option_continue },
		},
		{
			text = dialog_line(2),
			options = {
				{
					text = option_continue.text,
					func = function( dialog )
						local player_id = EntityGetWithTag( "player_unit" )[1]
						local x, y = EntityGetTransform( player_id )
						whoosh:init( {
							{ x, y },
							{ 120, 145, 120 },
							{ x, y },
						} )
						fn_on_point = {
							nil,
							function()
								load_tablet( 90, 120 )
								fn_on_point[2] = nil
							end,
							nil,
						}
						option_continue.func( dialog )
					end,
				},
			},
		},
		{
			text = dialog_line(3),
			options = {
				{
					text = option_continue.text,
					func = function( dialog )
						local player_id = EntityGetWithTag( "player_unit" )[1]
						local x, y = EntityGetTransform( player_id )
						whoosh:init( {
							{ x, y },
							{ 120, 145, 120 },
							{ x, y },
						} )
						fn_on_point = {
							nil,
							function()
								load_tablet( 120, 90 )
								load_tablet( 150, 60 )
								fn_on_point[2] = nil
							end,
							nil,
						}
						option_continue.func( dialog )
					end,
				},
			},
		},
		{
			text = dialog_line(4),
			options = {
				{
					text = option_continue.text,
					func = function( dialog )
						EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", 445, 50 )
						option_continue.func( dialog )
					end,
				},
			},
		},
		{
			text = dialog_line(5),
			options = {
				{ text = get_text( "dialog_option_end" ) },
			},
		},
	}

	local dialog_common_parts = {
		name = wrap_key( "veteran_npc_name" ),
		portrait = mod_path .. "files/veteran/portrait.png",
		typing_sound = "none",
	}
	for _, d in ipairs( dialog_lines ) do
		for k, v in pairs( dialog_common_parts ) do
			d[ k ] = v
		end
	end
end

ComponentSetValue2( ln_comp, "value_int", line_num )

if whoosh.inited then
	local dest_point_index = whoosh:update()
	if dest_point_index and fn_on_point then
		optional_call( fn_on_point[ dest_point_index - 1 ] )
	end
	if not whoosh.inited then
		fn_on_point = nil
		GameSetCameraFree( false )
	end
end

-- wake_up_waiting_threads( 1 )

if not EntityHasTag( entity_id, "invincible" ) then
	local x, y = EntityGetTransform( entity_id )
	local player = EntityGetInRadiusWithTag( x, y, 20, "player_unit" )
	if player and #player > 0 then
		EntityAddTag( entity_id, "invincible" )
		dialog_system.open_dialog( dialog_lines[ line_num ] )
	end
end

function interacting( entity_who_interacted, entity_interacted, interactable_name )
	dialog_system.open_dialog( dialog_lines[ line_num ] )
end
