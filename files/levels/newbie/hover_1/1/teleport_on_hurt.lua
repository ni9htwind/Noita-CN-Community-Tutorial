local teleport_to = { 19, 178 }

function damage_received( ... )
	EntitySetTransform( GetUpdatedEntityID(), unpack( teleport_to ) )
end
