local teleport_to = { 29, 123 }

function damage_received( ... )
	EntitySetTransform( GetUpdatedEntityID(), unpack( teleport_to ) )
end
