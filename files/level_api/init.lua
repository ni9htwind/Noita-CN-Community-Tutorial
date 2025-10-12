local nxml = dofile_once( mod_path .. "libs/nxml.lua" )

local biomes_file = "data/biome/_biomes_all.xml"
local biomes = nxml.parse( ModTextFileGetContent( biomes_file ) )

local biome = nxml.new_element( "Biome", {
	biome_filename = module_path .. "biome_blank/defination.xml",
	height_index = 1,
	color = "ffC0C0C0",
} )
biomes:add_child( biome )

ModTextFileSetContent_Saved( biomes_file, tostring( biomes ) )
