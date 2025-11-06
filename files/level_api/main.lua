local mod_path = "mods/community_tutorial/"

local nxml = dofile_once( mod_path .. "libs/nxml.lua" )

local biome_map_blank = mod_path .. "files/level_api/biome_map_blank.lua"

local level_api = {
	current = {
		level = nil,
		room_index = nil,
		state = {},
	},
}

function level_api:load( level, room_index )
	room_index = room_index or 1

	local room = level.rooms[ room_index ]

	local player_id = EntityGetWithTag( "player_unit" )[1]

	for _, comp_id in ipairs( EntityGetAllComponents( player_id ) ) do
		EntityRemoveComponent( player_id, comp_id )
	end
	EntityLoadToEntity( "data/entities/player_base.xml", player_id )

	for i = 0,7 do
		if InputIsJoystickConnected( i ) then
			EntitySetComponentsWithTagEnabled( player_id, "aiming_reticle", false )
			break
		end
	end

	for _, child_id in ipairs( EntityGetAllChildren( player_id ) ) do
		EntityRemoveFromParent( child_id )
		EntityKill( child_id )
	end
	EntityAddChild( player_id, EntityCreateNew( "inventory_quick" ) )
	EntityAddChild( player_id, EntityCreateNew( "inventory_full" ) )

	EntityAddComponent2( player_id, "MagicConvertMaterialComponent", {
		from_material_array = "community_tutorial.invisible_wall",
		to_material_array = "community_tutorial.visible_invisible_wall",
		radius = 16 + 1.5,
		steps_per_frame = 100,
		loop = true,
		kill_when_finished = false,
	} )
	EntityAddComponent2( player_id, "MagicConvertMaterialComponent", {
		from_material_array = "community_tutorial.visible_invisible_wall",
		to_material_array = "community_tutorial.invisible_wall",
		radius = 48 + 1.5,
		min_radius = 16 + 1.5,
		steps_per_frame = 100,
		loop = true,
		kill_when_finished = false,
	} )

	EntitySetTransform( player_id, unpack( room.starting_pos ) )

	if room.seed then
    	SetWorldSeed( seed )
	end

	local pixel_scenes = room.path .. "pixel_scenes.xml"
	if not ModTextFileGetContent( pixel_scenes ) then
		local xml_content = nxml.new_element("PixelScenes")

		local data = room.pixel_scenes

		local files = {}
		for _, file in ipairs( data.files or {} ) do
			local file_element = nxml.new_element("File")
			file_element.content = { file }
			files[ #files + 1 ] = file_element
		end
		if #files > 0 then
			xml_content:add_child( nxml.new_element( "PixelSceneFiles", nil, files ) )
		end

		local bgs = {}
		for _, bg in ipairs( data.bgs or {} ) do
			bgs[ #bgs + 1 ] = nxml.new_element( "Image", bg )
		end
		if #bgs > 0 then
			xml_content:add_child( nxml.new_element( "BackgroundImages", nil, bgs ) )
		end

		local buffered = {}
		for _, ps in ipairs( data.buffered or {} ) do
			ps.skip_biome_checks = true
			buffered[ #buffered + 1 ] = nxml.new_element( "PixelScene", ps )
		end
		if #buffered > 0 then
			xml_content:add_child( nxml.new_element( "mBufferedPixelScenes", nil, buffered ) )
		end

		ModTextFileSetContent_Saved( pixel_scenes, nxml.tostring( xml_content ) )
	end

	local biome_map = room.biome_map or biome_map_blank

	BiomeMapLoad_KeepPlayer( biome_map, pixel_scenes )

	self.current = {
		level = level,
		room_index = room_index,
		state = {},
	}

	-- EntityLoad( "data/entities/particles/supernova.xml", 0, 0 )
end

function level_api:room_update()
	if not self.current.level or not self.current.room_index then return end

	local room = self.current.level.rooms[ self.current.room_index ]
	local stages = room.stages

	if not stages then return end

	local state = self.current.state

	state.stage = state.stage or "start"

	room.stages[ state.stage ].update( state )

	if state.finished then
		if self.current.room_index < #self.current.level.rooms then
			-- TODO: Maybe some in-game messages?
			self:load( self.current.level, self.current.room_index + 1 )
		else
			-- TODO
		end
	end
end

return level_api
