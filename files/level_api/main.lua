local module_path = this_folder()

local nxml = dofile_once( mod_path .. "libs/nxml.lua" )

local biome_map_blank = module_path .. "biome_map_blank/script.lua"

local level_api = {}

function level_api:init_player( player_id )
	player_id = player_id or EntityGetWithTag( "player_unit" )[1]

	for _, child_id in ipairs( EntityGetAllChildren( player_id ) or {} ) do
		local name = EntityGetName( child_id )
		if name == "inventory_quick" or name == "inventory_full" then
			EntityRemoveFromParent( child_id )
			EntityKill( child_id )

			EntityAddChild( player_id, EntityCreateNew( name ) )
		end
	end

	local dm_comp = EntityGetFirstComponent( player_id, "DamageModelComponent" )
	ComponentSetValue2( dm_comp, "wait_for_kill_flag_on_death", true )

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

	EntityAddComponent2( player_id, "LuaComponent", {
		script_damage_received = module_path .. "reset_room_on_death.lua",
	} )
	EntityAddComponent2( player_id, "LuaComponent", {
		script_polymorphing_to = module_path .. "polymorph_tracker.lua",
	} )
end

function level_api:load( level, room_index )
	room_index = room_index or 1

	GlobalsSetValue( const.Globals_NotVanillaWorld, "1" )

	local room = level.rooms[ room_index ]

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

		ModTextFileSetContent( pixel_scenes, nxml.tostring( xml_content ) )
	end

	local biome_map = room.biome_map or biome_map_blank

	local old_player

	old_player = EntityGetWithTag( "player_unit" )[1]
	BiomeMapLoad( biome_map_blank )
	EntityRemoveTag( old_player, "player_unit" )
	EntityKill( old_player )

	old_player = EntityGetWithTag( "player_unit" )[1]
	BiomeMapLoad_KeepPlayer( biome_map, pixel_scenes )
	EntityRemoveTag( old_player, "player_unit" )
	EntityKill( old_player )

	self:init_player( EntityGetWithTag( "player_unit" )[1] )

	self.current = {
		level = level,
		room_index = room_index,
		state = { stage = "first" },
	}

	local world_state = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	ComponentSetValue2( world_state, "time_dt", 0 )
	ComponentSetValue2( world_state, "time", 0 )
	ComponentSetValue2( world_state, "time_total", 0 )
	ComponentSetValue2( world_state, "intro_weather", true )

	ModTextFileSetContent( const.Vfile_GuideText, "" )
end

function level_api:room_update()
	if not self.current then return end

	if GlobalsGetValue( const.Globals_RestartRoom, "" ) == "1" then
		GlobalsSetValue( const.Globals_RestartRoom, "" )
		self:load( self.current.level, self.current.room_index )
		return
	end

	local room = self.current.level.rooms[ self.current.room_index ]

	if not self.current.inited then
		self.current.inited = true
		local player_id = EntityGetWithTag( "player_unit" )[1]
		EntitySetTransform( player_id, unpack( room.starting_pos ) )
		optional_call( room.on_loaded, self.current.state )
	end

	if ModTextFileGetContent( const.Vfile_EnterNextRoom ) == "1" then
		ModTextFileSetContent( const.Vfile_EnterNextRoom, "" )
		local next_room_index = self.current.room_index + 1
		if next_room_index <= #self.current.level.rooms then
			self:load( self.current.level, next_room_index )
		else
			self:load( lounge )
		end
		return
	end

	local stages = room.stages
	if not stages then return end

	local state = self.current.state
	if not state.stage then return end

	optional_call( room.stages[ state.stage ], state )
end

return level_api
