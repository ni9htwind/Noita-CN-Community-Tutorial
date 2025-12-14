local mod_path = "mods/community_tutorial/"

local const = dofile_once( mod_path .. "files/constants.lua" )
local dialog_system = dofile_once( "mods/community_tutorial/libs/DialogSystem/dialog_system.lua" )

dofile_once( mod_path .. "files/misc_utils.lua" )

local num_tips = tonumber( GameTextGetTranslatedOrNot( "$community_tutorial_tips_max_index" ) )

local main_dialog = {
	name = wrap_key( "veteran_npc_name" ),
	portrait = mod_path .. "files/veteran/portrait.png",
	typing_sound = "none",
	text = nil, -- set later
	options = {
		{
			text = GameTextGet( wrap_key( "dialog_option_open_level_selector" ) ),
			func = function( dialog )
				ModTextFileSetContent( const.Vfile_LevelsGuiShowing, "1" )
			end,
		},
	},
}

local function open_dialog()
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + 99 )
	main_dialog.text = GameTextGetTranslatedOrNot( wrap_key( "tips_" .. Random( 1, num_tips ) ) )

	dialog_system.open_dialog( main_dialog )
end

local entity_id = GetUpdatedEntityID()
if not EntityHasTag( entity_id, "invincible" ) then
	local x, y = EntityGetTransform( entity_id )
	local player = EntityGetInRadiusWithTag( x, y, 20, "player_unit" )
	if player and #player > 0 then
		EntityAddTag( entity_id, "invincible" )
		open_dialog()
	end
end

function interacting( entity_who_interacted, entity_interacted, interactable_name )
	open_dialog()
end
