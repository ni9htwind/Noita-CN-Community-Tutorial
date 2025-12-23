local mod_path = "mods/community_tutorial/"

dofile_once( mod_path .. "files/misc_utils.lua" )
local const = dofile_once( mod_path .. "files/constants.lua" )

ModTextFileSetContent( const.Vfile_GuideText, wrap_key( "guide_enter_portal" ) )
