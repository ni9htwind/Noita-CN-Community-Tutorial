dofile_once( mod_path .. "files/misc_utils.lua" )

local chapter_list = get_globals( mod_path .. "files/levels/chapter_list.lua" ).chapter_list

local chapters, chapters_ordered = {}, {}
for i, v in ipairs( chapter_list ) do
	local chapter_id, chapter_path = unpack( v )
	local chapter = dofile( chapter_path .. "chapter.lua" )

	chapter.id = chapter_id
	chapter.path = chapter_path
	chapter.name = chapter.name or wrap_key( ("chapter_%s_name"):format( chapter_id ) )

	chapters[ chapter_id ] = chapter
	if not chapter.hidden then
		chapters_ordered[ #chapters_ordered + 1 ] = chapter
	end
end

local function get_levels( chapter )
	local levels, levels_ordered = {}, {}
	for i, level_id in ipairs( chapter.level_list or {} ) do
		local level_path = table.concat{ chapter.path, level_id, "/" }
		local level_lua = level_path .. "level.lua"
		if ModDoesFileExist( level_lua ) then
			_G.level_path = level_path
			level = dofile( level_lua )
			_G.level_path = nil
		else
			level = {}
		end

		level.id = level_id
		level.name = level.name or wrap_key( ("level_%s_name"):format( level_id ) )
		level.desc = level.desc or wrap_key( ("level_%s_desc"):format( level_id ) )
		level.path = level_path
		level.index = i

		levels[ level_id ] = level
		levels_ordered[ i ] = level
	end

	return levels, levels_ordered
end

local function get_rooms( level )
	local num_rooms = level.num_rooms
	if not num_rooms then
		local room = level.as_room

		room.name = level.name
		room.path = level.path
		return { level.as_room }
	end

	local rooms = {}

	for i = 1, num_rooms do
		local room_path = ("%s/%d/"):format( level.path, i )

		local room = dofile( room_path .. "room.lua" )

		room.name = room.name or wrap_key( ("level_%s_room_%d_name"):format( level.id, i ) )
		room.desc = room.desc or wrap_key( ("level_%s_room_%d_desc"):format( level.id, i ) )
		room.path = room_path

		rooms[ i ] = room
	end

	return rooms
end

for _, chapter in pairs( chapters ) do
	chapter.levels, chapter.levels_ordered = get_levels( chapter )
	for _, level in pairs( chapter.levels ) do
		level.rooms = get_rooms( level )
	end
end

return { chapters, chapters_ordered }
