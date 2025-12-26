local mod_path = "mods/community_tutorial/"

function collision_trigger( colliding_entity_id )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", x, y - 16 )
end
