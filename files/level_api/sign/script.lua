local mod_path = "mods/community_tutorial/"

dialog_system = dofile_once( mod_path .. "libs/DialogSystem/dialog_system.lua" )
dofile_once( mod_path .. "files/misc_utils.lua" )

function interacting( entity_who_interacted, entity_interacted, interactable_name )
	if dialog_system.is_open then return end
	open_dialog()
end

function open_dialog()
	local key, line_num_min, line_num_max
	for _, c in ipairs( EntityGetComponentIncludingDisabled( GetUpdatedEntityID(), "VariableStorageComponent" ) or {} ) do
		if ComponentGetValue2( c, "name" ) == "key" then
			key = ComponentGetValue2( c, "value_string" )
		elseif ComponentGetValue2( c, "name" ) == "line_num_min" then
			line_num_min = ComponentGetValue2( c, "value_int" )
		elseif ComponentGetValue2( c, "name" ) == "line_num_max" then
			line_num_max = ComponentGetValue2( c, "value_int" )
		end
	end

	local function dialog_line( index )
		return get_text( ("dialog_%s_%d"):format( key, index ) )
	end

	local line_num = line_num_min

	local function get_options()
		if line_num >= line_num_max then
			return { { text = get_text( "dialog_option_sign_end" ) } }
		end

		local option = {}
		option.text = get_text( "dialog_option_continue" )
		option.func = function( dialog )
			line_num = line_num + 1
			dialog.show{ text = dialog_line( line_num ), options = get_options() }
		end
		return { option }
	end

	local main_dialog = {
		name = wrap_key( "sign_npc_name" ),
		portrait = mod_path .. "files/level_api/sign/portrait.png",
		typing_sound = "none",
		text = dialog_line( line_num ),
		options = get_options()
	}

	dialog_system.open_dialog( main_dialog )
end

local entity_id = GetUpdatedEntityID()
if not EntityHasTag( entity_id, "invincible" ) then
	local x, y = EntityGetTransform( entity_id )
	local player = EntityGetInRadiusWithTag( x, y, 15, "player_unit" )
	if player and #player > 0 then
		EntityAddTag( entity_id, "invincible" )
		open_dialog()
	end
end
