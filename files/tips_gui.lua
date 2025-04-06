local num_tips = tonumber( GameTextGetTranslatedOrNot( "$community_tutorial_tips_max_index" ) )

local function show_tips( gui, x, y, text )
	local screen_width, screen_height = GuiGetScreenDimensions( gui )
	GuiBeginAutoBox( gui )
		GuiLayoutBeginVertical( gui, x * screen_width, y * screen_height + 5 + 2, true )
			GuiTextCentered( gui, 0, 0, "$community_tutorial_tips_title" )
			GuiTextCentered( gui, 0, 0, text )
		GuiLayoutEnd( gui )
	GuiZSetForNextWidget( gui, 1 )
	GuiEndAutoBoxNinePiece( gui )
end

local tips_gui = {}

function tips_gui.generate_random_tip_func( x, y, seed_x, seed_y )
	if not seed_x or not seed_y then
		seed_x, seed_y = GameGetCameraPos()
	end

	SetRandomSeed( seed_x, seed_y )
	tips = "$community_tutorial_tips_" .. Random( 1, num_tips )

	local gui = GuiCreate()
	return function()
		GuiStartFrame( gui )
		show_tips( gui, x, y, tips )
	end
end

return tips_gui