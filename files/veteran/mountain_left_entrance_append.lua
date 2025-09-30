local old_spawn_trees = spawn_trees
function spawn_trees( x, y, w, h )
	old_spawn_trees( x, y, w, h )
	EntityLoad( "mods/community_tutorial/files/veteran/entity.xml", x, y )
end
