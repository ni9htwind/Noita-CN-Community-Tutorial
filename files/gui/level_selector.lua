local image_path = this_folder() .. "images/"

local main_bar_y = 0
local main_bar_width_percent = 60 / 100
local main_bar_height = 12
local main_bar_vertical_center = ( main_bar_y + main_bar_height ) / 2 + 2

local chapter_selector_y = main_bar_y + 2
local chapter_selector_height = main_bar_height - 2 - 2

local black_alpha = 0.7

local chapter_width = 24
local chapter_height = 8

local level_button_image = image_path .. "spell_box.png"
local level_button_image_hovered = image_path .. "spell_box_0_hover.png"
local level_button_scale = 1.5
local level_button_size, _ = GuiGetImageDimensions( gui, level_button_image, level_button_scale )
local level_button_first_row_y_percent = 30 / 100
local level_button_num_per_row = 10
local level_button_row_per_page = 3
local level_button_num_per_page = level_button_num_per_row * level_button_row_per_page
local level_num_font = "data/fonts/font_small_numbers.xml"
local level_num_font_scale = 2
local level_page_button_x_percent = 15 / 100

local room_button_image = image_path .. "spell_box.png"
local room_button_image_hovered = image_path .. "spell_box_0_hover.png"
local room_button_scale = 1.5
local room_button_size, _ = GuiGetImageDimensions( gui, room_button_image, room_button_scale )
local level_large_button_size = 64
local level_large_button_scale = level_large_button_size / ( level_button_size / level_button_scale )
local level_large_button_y_percent = 40 / 100

local chapter_selected = chapters_ordered[1]
local chapter_highlight_last_x
local chapter_highlight_dest_x

local level_page = 1

local level_selected = nil

return function()
	reset_z()
	GuiZSet( gui, -65536 )

	screen_width, screen_height = GuiGetScreenDimensions( gui )

	GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )
	GuiOptionsAdd( gui, GUI_OPTION.HandleDoubleClickAsClick )
	GuiOptionsAdd( gui, GUI_OPTION.ClickCancelsDoubleClick )

	GuiZSetForNextWidget( gui, 1 )
	GuiImage( gui, get_id(), 0, 0, image_path .. "black.png", black_alpha,
		math.max( screen_width, screen_height ), math.max( screen_width, screen_height ), 0 )

	local main_bar_width = screen_width * main_bar_width_percent
	local main_bar_x = ( screen_width - main_bar_width ) / 2
	GuiImageNinePiece( gui, get_id(), main_bar_x + 2, main_bar_y + 2, main_bar_width - 4, 12, 1, image_path .. "9piece0_bar.png" )

	local chapter_selector_width = #chapters_ordered * ( chapter_width + 2 + 2 )
	local chapter_selector_x = ( screen_width - chapter_selector_width ) / 2
	GuiZSetForNextWidget( gui, -1 )
	GuiImageNinePiece( gui, get_id(), chapter_selector_x, chapter_selector_y + 2, chapter_selector_width, chapter_selector_height, 1,
		image_path .. "9piece0_bar_darker.png" )

	local chapter_x = chapter_selector_x
	for i, chapter in ipairs( chapters_ordered ) do
		if chapter.hidden then goto continue end

		GuiZSetForNextWidget( gui, -4 )
		if GuiImageButton( gui, get_id(), chapter_x + 2, chapter_selector_y + 2, "",
			transparent_image( chapter_width, chapter_height ) ) then
			chapter_selected = chapter
			level_page = 1
			level_selected = nil
		end

		if chapter_selected == chapter then
			if not chapter_highlight_last_x then
				chapter_highlight_last_x = chapter_x
			end
			chapter_highlight_dest_x = chapter_x
		end

		GuiZSetForNextWidget( gui, -3 )
		local _, text_height = GuiGetTextDimensions( gui, chapter.name )
		local text_y = main_bar_vertical_center - text_height / 2
		GuiTextCentered( gui, chapter_x + ( chapter_width + 2 ) / 2, text_y, chapter.name )

		chapter_x = chapter_x + chapter_width + 2 + 2

		::continue::
	end

	if chapter_selected then
		local dist = math.abs( chapter_highlight_last_x - chapter_highlight_dest_x )
		if dist > 0 then
			if dist >= 1 then
				chapter_highlight_last_x = ( chapter_highlight_last_x + 0.6 * chapter_highlight_dest_x ) / 1.6
			else
				chapter_highlight_last_x = chapter_highlight_dest_x
			end
		end

		GuiZSetForNextWidget( gui, -2 )
		GuiImageNinePiece( gui, get_id(), chapter_highlight_last_x, chapter_selector_y + 2,
			chapter_width + 2 + 2, chapter_height, 1, image_path .. "9piece0_highlight.png" )
	end

	local main_bar_right_end = screen_width - main_bar_x

	local button_close_x = main_bar_right_end - 4 - 8
	local button_close_y = main_bar_y + 8 / 2
	GuiZSetForNextWidget( gui, -1 )
	if GuiImageButton( gui, get_id(), button_close_x, button_close_y, "", image_path .. "button_close.png" ) then
		ModTextFileSetContent( const.Vfile_LevelsGuiShowing, "" )
	end

	do
		local button_lounge_width, button_lounge_height = 40, chapter_height
		local button_lounge_x = button_close_x - button_lounge_width - 16
		local button_lounge_y = chapter_selector_y
		GuiZSetForNextWidget( gui, -4 )
		GuiImageButton( gui, get_id(), button_lounge_x, button_lounge_y + 2, "",
			transparent_image( button_lounge_width, button_lounge_height ) )

		local left_click,_,hovered = previous_data( gui )
		if left_click then
			level_api:load( lounge )
			ModTextFileSetContent( const.Vfile_LevelsGuiShowing, "" )
		end

		GuiZSetForNextWidget( gui, -3 )
		local _, text_height = GuiGetTextDimensions( gui, wrap_key( "enter_lounge" ) )
		local text_y = main_bar_vertical_center - text_height / 2
		GuiTextCentered( gui, button_lounge_x + ( button_lounge_width + 2 ) / 2, text_y, wrap_key( "enter_lounge" ) )

		GuiZSetForNextWidget( gui, -2 )
		if hovered then
			GuiImageNinePiece( gui, get_id(), button_lounge_x, button_lounge_y + 2,
			button_lounge_width + 2 + 2, button_lounge_height, 1, image_path .. "9piece0_highlight.png" )
		else
			GuiImageNinePiece( gui, get_id(), button_lounge_x, button_lounge_y + 2,
			button_lounge_width + 2 + 2, button_lounge_height, 1, image_path .. "9piece0_bar_darker.png" )
		end
	end

	if level_selected then
		local level_large_button_x = screen_width / 2 - level_large_button_size / 2
		local level_large_button_y = screen_height * level_large_button_y_percent

		GuiImageButton( gui, get_id(), level_large_button_x, level_large_button_y, "",
			transparent_image( level_large_button_size ) )

		local _,_,hover = previous_data( gui )
		if hover then
			GuiImage( gui, get_id(), level_large_button_x, level_large_button_y, level_button_image_hovered, 1,
			level_large_button_scale, level_large_button_scale, 0 )
		else
			GuiImage( gui, get_id(), level_large_button_x, level_large_button_y, level_button_image, 1,
			level_large_button_scale, level_large_button_scale, 0 )
		end

		local level_large_num_font_scale = level_num_font_scale * ( level_large_button_size / level_button_size )
		local level_num_text = tostring( level_selected.index )
		local level_num_text_width, level_num_text_height =
			GuiGetTextDimensions( gui, level_num_text, level_large_num_font_scale, 0, level_num_font, true )
		level_num_text_width = level_large_num_font_scale * ( #level_num_text * 4 - 1 )
		GuiZSetForNextWidget( gui, -0.5 )
		GuiText( gui,
			level_large_button_x + level_large_button_size / 2 - level_num_text_width / 2,
			level_large_button_y + level_large_button_size / 2 - level_num_text_height / 2,
			level_num_text, level_large_num_font_scale, level_num_font, true )

		local room_row_left_end = horizontal_centered_x( #level_selected.rooms, room_button_size )
		local room_button_x = room_row_left_end
		local room_button_y = level_large_button_y + level_large_button_size + 2
		for i, room in ipairs( level_selected.rooms ) do
			if GuiImageButton( gui, get_id(), room_button_x, room_button_y, "", transparent_image( room_button_size ) ) then
				level_api:load( level_selected, i )
				ModTextFileSetContent( const.Vfile_LevelsGuiShowing, "" )
			end

			local _,_,hover = previous_data( gui )

			if hover then
				GuiImage( gui, get_id(), room_button_x, room_button_y, room_button_image_hovered, 1,
					room_button_scale, room_button_scale, 0 )
			else
				GuiImage( gui, get_id(), room_button_x, room_button_y, room_button_image, 1,
					room_button_scale, room_button_scale, 0 )
			end

			room_button_x = room_button_x + 2 + room_button_size
		end
	elseif chapter_selected then
		local left_end = horizontal_centered_x( level_button_num_per_row, level_button_size )
		local level_button_x = left_end
		local level_button_y = screen_height * level_button_first_row_y_percent
		local num_levels = #chapter_selected.levels_ordered
		for i = ( level_page - 1 ) * 30 + 1, math.min( level_page * 30, num_levels ) do
			local level = chapter_selected.levels_ordered[ i ]

			GuiZSetForNextWidget( gui, -1 )
			if GuiImageButton( gui, get_id(), level_button_x, level_button_y, "", transparent_image( level_button_size ) ) then
				if level.num_rooms == 1 then
					level_api:load( level )
					ModTextFileSetContent( const.Vfile_LevelsGuiShowing, "" )
				else
					level_selected = level
				end
			end
			local _,_,hover = previous_data( gui )
			if hover then
				GuiImage( gui, get_id(), level_button_x, level_button_y, level_button_image_hovered, 1,
					level_button_scale, level_button_scale, 0 )
			else
				GuiImage( gui, get_id(), level_button_x, level_button_y, level_button_image, 1,
					level_button_scale, level_button_scale, 0 )
			end

			local level_num_text = tostring( i )
			local level_num_text_width, level_num_text_height =
				GuiGetTextDimensions( gui, level_num_text, level_num_font_scale, 0, level_num_font, true )
			level_num_text_width = level_num_font_scale * ( #level_num_text * 4 - 1 )
			GuiZSetForNextWidget( gui, -0.5 )
			GuiText( gui,
				level_button_x + level_button_size / 2 - level_num_text_width / 2,
				level_button_y + level_button_size / 2 - level_num_text_height / 2,
				level_num_text, level_num_font_scale, level_num_font, true )

			if i % level_button_num_per_row == 0 then
				level_button_x = left_end
				level_button_y = level_button_y + level_button_size + 2
			else
				level_button_x = level_button_x + level_button_size + 2
			end
		end

		local level_page_button_x = screen_width * level_page_button_x_percent
		local level_page_button_y = screen_height * level_button_first_row_y_percent +
			level_button_size * ( level_button_row_per_page - 1 ) / 2 + 2
		if level_page ~= 1 then
			if GuiImageButton( gui, get_id(), level_page_button_x, level_page_button_y, "",
				transparent_image( level_button_size ) ) then
				level_page = level_page - 1
			end
			GuiImage( gui, get_id(), level_page_button_x, level_page_button_y, image_path .. "pagelast.png", 1,
				level_button_scale, level_button_scale, 0 )
		end
		if num_levels > level_page * 30 then
			local next_page_button_x = screen_width - level_page_button_x - level_button_size
			if GuiImageButton( gui, get_id(), next_page_button_x, level_page_button_y, "",
				transparent_image( level_button_size ) ) then
				level_page = level_page + 1
			end
			GuiImage( gui, get_id(), next_page_button_x, level_page_button_y, image_path .. "pagenext.png", 1,
				level_button_scale, level_button_scale, 0 )
		end
	end
end