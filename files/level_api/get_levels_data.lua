dofile_once( mod_path .. "files/misc_utils.lua" )

local chapter_list = get_globals( mod_path .. "files/levels/chapter_list.lua" ).chapter_list

local chapters = {}
for i, v in ipairs( chapter_list ) do
	local chapter_id, chapter_path = unpack( v )
	local chapter = dofile_once( chapter_path .. "chapter.lua" )

	chapter.id = chapter_id
	chapter.path = chapter_path
	chapter.name = chapter.name or wrap_key( ("chapter_%s_name"):format( chapter_id ) )

	chapters[ i ] = chapter
end

local function get_levels( chapter )
	local levels = {}
	for i, level_id in ipairs( chapter.level_list or {} ) do
		local level_path = table.concat{ chapter.path, level_id, "/" }
		local level_lua = level_path .. "level.lua"
		local level
		if ModDoesFileExist( level_lua ) then
			level = dofile_once( level_lua )
		else
			level = {}
		end

		level.id = level_id
		level.name = level.name or wrap_key( ("level_%s_name"):format( level_id ) )
		level.desc = level.desc or wrap_key( ("level_%s_desc"):format( level_id ) )
		level.path = level_path

		levels[ i ] = level
	end

	return levels
end

local function get_rooms( level )
	local num_rooms = level.num_rooms
	if not num_rooms or num_rooms == 1 then
		return { { pixel_scene = { level.path .. "/materials.png", level.path .. "/colors.png" } } }
	end

	local rooms = {}
	for i = 1, num_rooms do
		local materials_file = ("%s/room_%d_materials.png"):format( level.path, i )
		local colors_file = ("%s/room_%d_colors.png"):format( level.path, i )

		if not ModDoesFileExist( materials_file ) then
			print_error( ("Materials file doesn't exist in level %s, room %d"):format( level.name, i ) )
		end
		if not ModDoesFileExist( colors_file ) then
			print_error( ("Materials file doesn't exist in level %s, room %d"):format( level.name, i ) )
		end

		local room = { pixel_scene = { materials_file, colors_file } }
		room.name = room.name or wrap_key( ("level_%s_room_%d_name"):format( level.id, i ) )
		room.desc = room.desc or wrap_key( ("level_%s_room_%d_desc"):format( level.id, i ) )

		rooms[ i ] = room
	end

	return rooms
end

for _, chapter in ipairs( chapters ) do
	chapter.levels = get_levels( chapter )
	for _, level in ipairs( chapter.levels ) do
		level.rooms = get_rooms( level )
	end
end

return chapters