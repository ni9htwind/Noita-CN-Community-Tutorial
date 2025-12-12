local image_path = this_folder() .. "images/"

local button_image = image_path .. "level_selector_entry_point.png"
local button_height, button_width = GuiGetImageDimensions( gui, button_image )

return function()
	reset_z()

	local button_x = 2
	local button_y = screen_height - button_height - 2

	GuiImageButton( gui, get_id(), button_x, button_y, "", transparent_image( button_width, button_height ) )
	local left_click,_,hovered = previous_data( gui )
	if left_click then
		ModTextFileSetContent( const.Vfile_LevelsGuiShowing, "1" )
	end

	GuiZSetForNextWidget( gui, -1 )
	GuiImage( gui, get_id(), button_x, button_y, button_image, 1, 1, 1, 0 )
	if hovered then
		GuiImageNinePiece( gui, get_id(), button_x + 2, button_y + 2, button_width - 4, button_height - 4, 1, 
			image_path .. "9piece0_highlight.png" )
	else
		GuiImageNinePiece( gui, get_id(), button_x + 2, button_y + 2, button_width - 4, button_height - 4, 1,
			image_path .. "9piece0_bar.png" )
	end
end
