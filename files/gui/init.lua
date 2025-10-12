local main_lua = module_path .. "main.lua"
function OnWorldPreUpdate()
	dofile( main_lua )
end