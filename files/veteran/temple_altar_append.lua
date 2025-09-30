local old_spawn_hp = spawn_hp
function spawn_hp( x, y )
	old_spawn_hp( x, y )
	EntityLoad( "mods/community_tutorial/files/veteran/entity.xml", x - 214, y + 57 )
end
