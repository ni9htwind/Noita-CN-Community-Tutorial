local dialog_system = dofile_once( "mods/community_tutorial/libs/DialogSystem/dialog_system.lua" )
local num_tips = tonumber( GameTextGetTranslatedOrNot( "$community_tutorial_tips_max_index" ) )

function interacting( entity_who_interacted, entity_interacted, interactable_name )
	SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + 99 )
	dialog_system.open_dialog{
		name = "$community_tutorial_veteran_npc_name",
		portrait = "mods/community_tutorial/files/veteran/portrait.png",
		typing_sound = "none",
		text = GameTextGetTranslatedOrNot( "$community_tutorial_tips_" .. Random( 1, num_tips ) ),
		options = {
			{
				text = "测试文本1",
			},
			{
				text = "测试文本2",
			},
		},
	}
end