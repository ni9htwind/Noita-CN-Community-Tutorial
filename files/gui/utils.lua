local gui_z = 0
do
	local old_GuiZSet = GuiZSet
	function GuiZSet( gui, z )
		gui_z = gui_z + z
		old_GuiZSet( gui, gui_z )
	end

	local old_GuiZSetForNextWidget = GuiZSetForNextWidget
	function GuiZSetForNextWidget( gui, z )
		old_GuiZSetForNextWidget( gui, gui_z + z )
	end
end
function reset_z()
	gui_z = 0
end

local cache_frame
local cached_mouse_x, cached_mouse_y
function get_mouse_pos_on_screen()
	if now ~= cache_frame or not cached_mouse_x or not cached_mouse_y then
		cached_mouse_x, cached_mouse_y = get_screen_position( DEBUG_GetMouseWorld() )
		cache_frame = now
	end
	return cached_mouse_x, cached_mouse_y
end

function percent_to_ui_scale_y( y )
	return y * screen_height / 100
end

function horizontal_centered_x( buttons_num, button_width )
	return screen_width / 2 - ( buttons_num * ( button_width + 2 ) - 2 ) / 2
end

function get_screen_position( x, y )
	local camera_x, camera_y = GameGetCameraPos()
	local res_width = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_X" )
	local res_height = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_Y" )
	local ax = (x - camera_x) / res_width * screen_width
	local ay = (y - camera_y) / res_height * screen_height
	return ax + screen_width * 0.5, ay + screen_height * 0.5
end

function get_world_position( x, y )
	local camera_x, camera_y = GameGetCameraPos()
	local res_width = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_X" )
	local res_height = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_Y" )
	local ax, ay = x - screen_width * 0.5, y - screen_height * 0.5
	local wx = ax * res_width / screen_width + camera_x
	local wy = ay * res_height / screen_height + camera_y
	return wx, wy
end

function previous_data( gui )
	return GuiGetPreviousWidgetInfo( gui )
end

function sound_button_clicked()
	if mod_setting_get( "button_click_sound" ) then
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_click", GameGetCameraPos() )
	end
end

function sound_action_button_clicked()
	if mod_setting_get( "action_button_click_sound" ) then
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_click", GameGetCameraPos() )
	end
end

function previous_hovered( margin )
	margin = margin or 0
	local mx, my = get_mouse_pos_on_screen()
	local _,_,_,x,y,width,height,_,_,_,_ = previous_data( gui )
	return -margin + x < mx and mx < x + width + margin and -margin + y < my and my < y + height + margin
end

function transparent_image( width, height )
	height = height or width
	local filename = ("%sfiles/gui/images/transparent_%dx%d.png"):format( mod_path, width, height )
	if not ModDoesFileExist( filename ) then
		print_error( "File does not exist:", filename )
	end
	return filename
end
