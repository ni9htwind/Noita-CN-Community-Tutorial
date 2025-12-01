local mod_path = "mods/community_tutorial/"

local vfile_folder = mod_path .. "vfiles/"
local globals_prefix = "community_tutorial."
return {
	Vfile_LevelsGuiShowing = vfile_folder .. "levels_gui_showing.txt",
	Globals_NotVanillaWorld = globals_prefix .. "not_vanilla_world",
	Globals_RestartRoom = globals_prefix .. "restart_room",
	Vfile_PlayerPolymorphingTo = vfile_folder .. "player_polymorphing_to.txt",
}
