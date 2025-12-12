local image_path = this_folder() .. "images/"

local bar_width_percent = 40 / 100
local bar_height = 200
local bar_y_offset_percent = 0 / 100
return function()
	-- local bar_width = bar_width_percent * screen_width
	reset_z()
	GuiZSet( gui, -28362836 )
	local bar_width = 140
	local bar_x = screen_width / 2 - bar_width / 2
	local bar_y = screen_height / 2 - bar_height / 2 - bar_y_offset_percent * screen_height
	GuiImageNinePiece( gui, get_id(), bar_x, bar_y, bar_width, bar_height, 1, image_path .. "9piece0_bar.png" )
end
