local module_path = this_folder()
local nxml = dofile_once( mod_path .. "libs/nxml.lua" )

local biomes_file = "data/biome/_biomes_all.xml"
local biomes = nxml.parse( ModTextFileGetContent( biomes_file ) )

local biome = nxml.new_element( "Biome", {
	biome_filename = module_path .. "biome_map_blank/biome_blank/defination.xml",
	height_index = 1,
	color = "ffC0C0C0",
} )
biomes:add_child( biome )

ModTextFileSetContent( biomes_file, tostring( biomes ) )

ModMaterialsFileAdd( module_path .. "materials.xml" )

local callbacks = {}

function callbacks.OnWorldPreUpdate()
	do
		local polymorphed_player = ModTextFileGetContent( const.Vfile_PlayerPolymorphingTo )
		if polymorphed_player and polymorphed_player ~= "" then
			ModTextFileSetContent( const.Vfile_PlayerPolymorphingTo, "" )
			EntityAddComponent2( tonumber(polymorphed_player), "LuaComponent", {
				script_damage_received = module_path .. "reset_room_on_death.lua",
			} )
			local dm_comp = EntityGetFirstComponent( polymorphed_player, "DamageModelComponent" )
			if dm_comp then
				ComponentSetValue2( dm_comp, "wait_for_kill_flag_on_death", true )
			end
		end
	end
	level_api:room_update()
end

return callbacks
