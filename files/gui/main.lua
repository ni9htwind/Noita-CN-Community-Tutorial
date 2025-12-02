local module_path = this_folder()

dofile_once( module_path .. "utils.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( mod_path .. "files/misc_utils.lua" )

image_path = module_path .. "images/"

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
	end

	dofile_once( module_path .. "level_guide.lua" )()
end
