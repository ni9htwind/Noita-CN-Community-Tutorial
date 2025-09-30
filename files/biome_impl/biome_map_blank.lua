-- constants (color format is ARGB)
dofile_once( "data/scripts/lib/utilities.lua" )

BIOME_MAP_WIDTH = 64
BIOME_MAP_HEIGHT = 48

function paint_biome_area( x, y, w, h, biome_color, buffer )
	local extra_width = Random( 0, buffer )
	x = x - extra_width
	w = w + extra_width + Random( 0, buffer )

	for iy = y, y + h - 1 do
		for ix = x, x + w - 1 do
			BiomeMapSetPixel( ix, iy, biome_color )
		end
	end
end

BiomeMapSetSize( BIOME_MAP_WIDTH, BIOME_MAP_HEIGHT )
BiomeMapLoadImage( 0, 0, "data/biome_impl/biome_map_nil.png" )

SetRandomSeed( GameGetFrameNum(), -GameGetFrameNum() )

local biome_nil = 0xFF808080

-- biome nil
paint_biome_area( 0, 0, 64, 48,  biome_nil, 0 )

local world_state_entity = GameGetWorldStateEntity()
local comp = EntityGetComponent( world_state_entity, "WorldStateComponent" )

if ( comp ~= nil ) then
	orb_map_update()
end
