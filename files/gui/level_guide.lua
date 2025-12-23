local image_path = this_folder() .. "images/"

local icon_image = image_path .. "level_guide.png"
local icon_height, icon_width = GuiGetImageDimensions( gui, icon_image )
local image_9piece_gray = "data/ui_gfx/decorations/9piece0_gray.png"

return function()
	local guide_text = ModTextFileGetContent( const.Vfile_GuideText )
	if not guide_text or guide_text == "" then return end

	reset_z()

	local icon_x = 2 + icon_width + 2
	local icon_y = screen_height - icon_height - 2

	GuiZSetForNextWidget( gui, -3 )
	GuiImage( gui, get_id(), icon_x, icon_y, icon_image, 1, 1, 1, 0 )
	GuiZSetForNextWidget( gui, -2 )
	GuiImageNinePiece( gui, get_id(), icon_x + 2, icon_y + 2, icon_width - 4, icon_height - 4, 1, image_9piece_gray )

	guide_text = GameTextGetTranslatedOrNot( guide_text )
	local guide_text_width, guide_text_height = GuiGetTextDimensions( gui, guide_text )
	local guide_text_x = icon_x + icon_width + 4
	local guide_text_y = icon_y + icon_height / 2 - guide_text_height / 2

	GuiZSetForNextWidget( gui, -1 )
	GuiText( gui, guide_text_x, guide_text_y, guide_text )

	local guide_box_width = icon_width + 2 + 2 + guide_text_width + 2
	local guide_box_height = icon_height - 2 - 2
	local guide_box_x = icon_x + 2
	local guide_box_y = icon_y + 2

	GuiImageNinePiece( gui, get_id(), guide_box_x, guide_box_y, guide_box_width, guide_box_height, 1, image_9piece_gray )
end
