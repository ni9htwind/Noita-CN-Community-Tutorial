local module_path = this_folder()
local image_path = module_path .. "images/"

dofile_once( module_path .. "utils.lua" )
dofile_once( mod_path .. "files/misc_utils.lua" )

GUI_OPTION = get_globals( "data/scripts/lib/utilities.lua" ).GUI_OPTION

local id_allocator = dofile_once( module_path .. "id_allocator.lua" )
get_id = id_allocator.get_id

gui = GuiCreate()

return function()
	now = GameGetFrameNum()
	id_allocator.new_frame()

	GuiStartFrame( gui )

	screen_width, screen_height = GuiGetScreenDimensions( gui )

	GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )
	GuiOptionsAdd( gui, GUI_OPTION.HandleDoubleClickAsClick )
	GuiOptionsAdd( gui, GUI_OPTION.ClickCancelsDoubleClick )

	if ModTextFileGetContent( const.Vfile_LevelsGuiShowing ) == "1" then
		dofile_once( module_path .. "level_selector.lua" )()
	else
		if GlobalsGetValue( const.Globals_NotVanillaWorld, "" ) == "1" then
			dofile_once( module_path .. "level_selector_entry_point.lua" )()
		end
	end

	dofile_once( module_path .. "level_guide.lua" )()

	if level_api.current and level_api.current.state.finished then
		dofile_once( module_path .. "level_finished.lua" )()
	end
end
