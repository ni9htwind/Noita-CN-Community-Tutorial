local module_path = this_folder()

local callbacks = {}

local main_lua = module_path .. "main.lua"
function callbacks.OnWorldPreUpdate()
	dofile_once( main_lua )()
end

return callbacks
