local module_path = this_folder()
local const = dofile_once( mod_path .. "files/constants.lua" )

local function set_pixel( pixel_scene_image, x, y, color )
	ModImageSetPixel( ModImageMakeEditable( pixel_scene_image, 0, 0 ), x, y, color )
end

local pattern = [[%s
RegisterSpawnFunction( 0x%s, "spawn_veteran" )
function spawn_veteran( x, y )
	if GlobalsGetValue( "]] .. const.Globals_NotVanillaWorld .. [[", "0" ) ~= "1" then
		EntityLoad( "%s", x, y )
	end
end
]]

local function append_spawn_func( script, color_argb, entity_file )
	ModTextFileSetContent( script, pattern:format( ModTextFileGetContent( script ), color_argb, entity_file ) )
end

local function register_entity_spawn( t )
	local x, y = unpack( t.pos )
	set_pixel( t.pixel_scene_image, x, y, tonumber( "0x" .. t.color_abgr ) )
	append_spawn_func( t.script, t.color_argb, t.entity )
end

local mountain = {
	pixel_scene_image = "data/biome_impl/mountain/left_entrance.png",
	script = "data/scripts/biomes/mountain/mountain_left_entrance.lua",
	entity = module_path .. "entity.xml",
	color_argb = "ffAEFD0D",
	color_abgr = "ff0DFDAE",
	pos = { 277, 430 },
}


local temple = {
	pixel_scene_image = "data/biome_impl/temple/altar_left.png",
	script = "data/scripts/biomes/temple_altar_left.lua",
	entity = module_path .. "entity.xml", -- TODO: make them different
	color_argb = "ffAEFD1D",
	color_abgr = "ff1DFDAE",
	pos = { 343, 131 },
}

register_entity_spawn( mountain )
register_entity_spawn( temple )
