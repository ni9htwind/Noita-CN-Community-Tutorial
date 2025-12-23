local mod_path = "mods/community_tutorial/"

local dialog_system = dofile_once( mod_path .. "libs/DialogSystem/dialog_system.lua" )
if not whoosh then
	whoosh = dofile_once( mod_path .. "libs/whoosh.lua" )

	local player_id = EntityGetWithTag( "player_unit" )[1]
	local psp_comp = EntityGetFirstComponent( player_id, "PlatformShooterPlayerComponent" )
	whoosh.pos_setter = function( pos )
		ComponentSetValue2( psp_comp, "mDesiredCameraPos", unpack( pos ) )
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

if not dialog_lines then
	local function load_tablet( x, y )
		local tablet_id = EntityLoad( "data/entities/items/books/book_corpse.xml", x, y )
		EntityAddComponent2( tablet_id, "LifetimeComponent", { lifetime = 120 } )
		EntityLoad( room_path .. "tablet_marker.xml", x, y )
	end

	local text_continue = get_text( "dialog_option_continue" )
	local text_previous = get_text( "dialog_option_previous" )

	dialog_lines = {
		{
			text = dialog_line(1),
			options = {
				{
					text = text_continue,
					func = function( dialog )
						dialog.show( dialog_lines[2] )
					end,
				},
			},
		},
		{
			text = dialog_line(2),
			options = {
				{
					text = text_continue,
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
						dialog.show( dialog_lines[3] )
					end,
				},
				{
					text = text_previous,
					func = function(dialog)
						dialog.show(dialog_lines[1])
					end,
				},
			},
		},
		{
			text = dialog_line(3),
			options = {
				{
					text = text_continue,
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
						dialog.show( dialog_lines[4] )
					end,
				},
				{
					text = text_previous,
					func = function(dialog)
						dialog.show(dialog_lines[2])
					end,
				},
			},
		},
		{
			text = dialog_line(4),
			options = {
				{
					text = text_continue,
					func = function( dialog )
						EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", 445, 50 )
						dialog.show( dialog_lines[5] )
					end,
				},
				{
					text = text_previous,
					func = function(dialog)
						dialog.show(dialog_lines[3])
					end,
				},
			},
		},
		{
			text = dialog_line(5),
			options = {
				{ text = get_text("dialog_option_end") },
				{
					text = text_previous,
					func = function(dialog)
						dialog.show(dialog_lines[4])
					end,
				},
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

if whoosh.inited then
	local dest_point_index = whoosh:update()
	if dest_point_index and fn_on_point then
		optional_call( fn_on_point[ dest_point_index - 1 ] )
	end
	if not whoosh.inited then
		fn_on_point = {}
	end
end

if not EntityHasTag( entity_id, "invincible" ) then
	local x, y = EntityGetTransform( entity_id )
	local player = EntityGetInRadiusWithTag( x, y, 20, "player_unit" )
	if player and #player > 0 then
		EntityAddTag( entity_id, "invincible" )
		dialog_system.open_dialog( dialog_lines[1] )
	end
end

function interacting( entity_who_interacted, entity_interacted, interactable_name )
	dialog_system.open_dialog( dialog_lines[1] )
end
