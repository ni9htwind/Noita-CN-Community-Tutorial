local teleport_to = { 36, 48 }

function damage_received( ... )
	EntitySetTransform( GetUpdatedEntityID(), unpack( teleport_to ) )
end
