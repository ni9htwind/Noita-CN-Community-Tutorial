dofile_once( mod_path .. "files/gui/utils.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )

if do_gui then
	do_gui()
	return
end

chapters = {}

local id_allocator = dofile_once( mod_path .. "files/gui/id_allocator.lua" )
get_id = id_allocator.get_id

gui = GuiCreate()

local main_bar_width_percent = 60 / 100
local black_alpha = 0.7
function do_gui()
	now = GameGetFrameNum()
	id_allocator.new_frame()

	GuiStartFrame( gui )
	reset_z()
	GuiZSet( gui, -65536 )

	screen_width, screen_height = GuiGetScreenDimensions( gui )

	GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )
	GuiOptionsAdd( gui, GUI_OPTION.HandleDoubleClickAsClick )
	GuiOptionsAdd( gui, GUI_OPTION.ClickCancelsDoubleClick )

	local main_bar_width = screen_width * main_bar_width_percent
	local main_bar_x = ( screen_width - main_bar_width ) / 2
	GuiImageNinePiece( gui, get_id(), main_bar_x + 2, 2, main_bar_width - 4, 12, 1,
		mod_path .. "files/gui/images/9piece0_bar.png" )

	GuiZSetForNextWidget( gui, 1 )
	GuiImage( gui, get_id(), 0, 0,
		mod_path .. "files/gui/images/black.png", black_alpha, math.max( screen_width, screen_height ), math.max( screen_width, screen_height ), 0 )
end