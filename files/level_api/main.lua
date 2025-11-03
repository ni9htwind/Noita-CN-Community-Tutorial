local mod_path = "mods/community_tutorial/"

local biome_map_blank = mod_path .. "files/level_api/biome_map_blank.lua"

local level_api = {
	current_level = nil,
	current_room = nil,
	current_room_state = {},
}

function level_api:load( level, room_index )
	room_index = room_index or 1

	local player_id = EntityGetWithTag( "player_unit" )[1]

	for _, comp_id in ipairs( EntityGetAllComponents( player_id ) ) do
		EntityRemoveComponent( player_id, comp_id )
	end
	EntityLoadToEntity( "data/entities/player_base.xml", player_id )

	for _, child_id in ipairs( EntityGetAllChildren( player_id ) ) do
		EntityRemoveFromParent( child_id )
		EntityKill( child_id )
	end
	EntityAddChild( player_id, EntityCreateNew( "inventory_quick" ) )
	EntityAddChild( player_id, EntityCreateNew( "inventory_full" ) )

	EntityAddComponent2( player_id, "MagicConvertMaterialComponent", {
		from_material_array = "community_tutorial.invisible_wall",
		to_material_array = "community_tutorial.visible_invisible_wall",
		radius = 16,
		loop = true,
		kill_when_finished = false,
	} )
	EntityAddComponent2( player_id, "MagicConvertMaterialComponent", {
		from_material_array = "community_tutorial.visible_invisible_wall",
		to_material_array = "community_tutorial.invisible_wall",
		radius = 32,
		min_radius = 16,
		loop = true,
		kill_when_finished = false,
	} )

	local room = level.rooms[ room_index ]

	if room.seed then
    	SetWorldSeed( seed )
	end

	local pixel_scenes = room.path .. "pixel_scenes.xml"

	local biome_map = room.biome_map or biome_map_blank

	BiomeMapLoad_KeepPlayer( biome_map, pixel_scenes )

	EntitySetTransform( player_id, room.starting_pos_x or 0, room.starting_pos_y or 0 )

	self.current_level = level
	self.current_room_index = room_index

	self.current_room_state = {}

	-- EntityLoad( "data/entities/particles/supernova.xml", 0, 0 )
end

function level_api:room_update()
	if not self.current_level or not self.current_room_index then return end

	local room = self.current_level.rooms[ self.current_room_index ]
	local stages = room.stages

	if not stages then return end

	local current_room_state = self.current_room_state

	current_room_state.stage = current_room_state.stage or "start"

	room.stages[ current_room_state.stage ].update( current_room_state )

	if current_room_state.finished then
		if self.current_room_index < #self.current_level.rooms then
			-- TODO: Maybe some in-game messages?
			self:load( self.current_level, self.current_room_index + 1 )
		else
			-- TODO
		end
	end
end

return level_api