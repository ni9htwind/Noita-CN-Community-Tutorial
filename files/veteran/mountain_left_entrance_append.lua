local old_init = init
function init( x, y, w, h )
	old_init( x, y, w, h )
	EntityLoad( "mods/community_tutorial/files/veteran/entity.xml", 0, 0 )
end
