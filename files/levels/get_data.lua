dofile_once( mod_path .. "files/misc_utils.lua" )

local chapter_list = get_globals( mod_path .. "files/levels/chapter_list.lua" ).chapter_list

local chapters = {}
for i, v in ipairs( chapter_list ) do
	local chapter_id, chapter_path = unpack( v )
	local chapter = dofile_once( chapter_path .. "chapter.lua" )

	chapter.path = chapter_path
	chapter.name = chapter.ui_name or wrap_key( ("chapter_%s_name"):format( chapter_id ) )

	chapters[ i ] = chapter
end

local function get_levels( chapter )
	local levels = {}
	for i, level_id in ipairs( chapter.level_list or {} ) do
		local level_path = table.concat{ chapter_path, level_id, "/" }
		local level = dofile_once( level_path .. "level.lua" )

		level.name = level.name or wrap_key( ("level_%s_name"):format( chapter_id ) )
		level.name = level.description or wrap_key( ("level_%s_description"):format( chapter_id ) )
		level.path = level_path

		levels[ i ] = level
	end

	return levels
end

local function get_rooms( level )
	local num_rooms = level.num_rooms
	if not level.rooms or level.rooms <= 1 then return nil end

	local rooms = {}
	for i, v in ipairs(  ) do
		local room = {}
		-- TODO
		rooms = {}
		::continue::
	end

	return rooms
end