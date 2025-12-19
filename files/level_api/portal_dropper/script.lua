local mod_path = "mods/community_tutorial/"

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()

	local x, y = EntityGetTransform( entity_id )
	for _, c in ipairs( EntityGetComponentIncludingDisabled( entity_id, "VariableStorageComponent" ) or {} ) do
		if ComponentGetValue2( c, "name" ) == "x" then
			x = ComponentGetValue2( c, "value_int" )
		elseif ComponentGetValue2( c, "name" ) == "y" then
			y = ComponentGetValue2( c, "value_int" )
		end
	end
	EntityLoad( mod_path .. "files/level_api/portal_next_room/entity.xml", x, y )
end
