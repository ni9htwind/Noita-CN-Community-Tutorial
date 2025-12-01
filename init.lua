mod_id = "community_tutorial"
mod_path = "mods/community_tutorial/"

setmetatable( _G, { __index = { ModTextFileSetContent = ModTextFileSetContent } } )

dofile_once( mod_path .. "files/misc_utils.lua" )

local translations = ModTextFileGetContent( mod_path .. "translations.csv" )
local main = "data/translations/common.csv"
local main_content = ModTextFileGetContent( main )
if main_content:sub( #main_content, #main_content ) ~= "\n" then
	main_content = main_content .. "\n"
end

ModTextFileSetContent( main, main_content .. translations:gsub( "^[^\n]*\n", "", 1 ) )

dofile_once( mod_path .. "libs/DialogSystem/init.lua" )( mod_path .. "libs/DialogSystem" )
dofile_once( mod_path .. "libs/polytools/polytools_init.lua" ).init( mod_path .. "libs/polytools/" )

const = dofile_once( mod_path .. "files/constants.lua" )
chapters = dofile_once_wrapped( mod_path .. "files/levels/get_levels_data.lua" )
level_api = dofile_once( mod_path .. "files/level_api/main.lua" )

local modules = {
	"gui",
	"level_api",
	"levels",
	"veteran",
}

local callbacks = {
	OnBiomeConfigLoaded = {},
	OnCountSecrets = {},
	OnMagicNumbersAndWorldSeedInitialized = {},
	OnModInit = {},
	OnModPostInit = {},
	OnModPreInit = {},
	OnModSettingsChanged = {},
	OnPausePreUpdate = {},
	OnPausedChanged = {},
	OnPlayerDied = {},
	OnPlayerSpawned = {},
	OnWorldInitialized = {},
	OnWorldPostUpdate = {},
	OnWorldPreUpdate = {},
}

local _module_path = mod_path .. "files/%s/"

for _, module in ipairs( modules ) do
	local module_path = _module_path:format( module )

	local init_lua = module_path .. "init.lua"
	if not ModDoesFileExist( init_lua ) then goto continue end

	local globals = get_globals( init_lua, { module_path = module_path } )

	for name, funcs in pairs( callbacks ) do
		local f = globals[ name ]
		if f then
			funcs[ #funcs + 1 ] = f
		end
	end

	::continue::
end

for name, funcs in pairs( callbacks ) do
	if #funcs > 0 then
		_G[ name ] = function( ... )
			for _, f in ipairs( funcs ) do f( ... ) end
		end
	end
end
