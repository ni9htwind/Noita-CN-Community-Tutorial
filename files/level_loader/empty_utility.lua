mod_path = "mods/community_tutorial/files/"

dofile_once( "data/scripts/perks/perk.lua" )
dofile_once( mod_path .. "scripts/tutorial/levels_info.lua" )

---@return nil
function delete_other_entities()
	local entities = EntityGetInRadius( 0, 0, 80000 )

	for _, entity in ipairs( entities ) do
		if ( not EntityHasTag( entity, "player_unit" ) ) then
			EntityKill( entity )
		end
	end
end

---传送所有玩家至坐标 ( x, y )
---@param x number
---@param y number
---@return nil
function teleport_players( x, y )
	local players = EntityGetWithTag( "player_unit" )

	for _, player in ipairs( players ) do
		EntityApplyTransform( player, x, y )
	end
end

---清空所有玩家黄金、法杖、物品与天赋
---@return nil
function clean_all() -- //TODO: 也许应该把沾染状态也清了?
	local players = EntityGetWithTag( "player_unit" )

	for _, player in ipairs( players ) do
		-- gold = 0
		local gold = EntityGetFirstComponent( player, "WalletComponent" )
		if ( gold ) then
			ComponentSetValue2( gold, "money", 0 )
		end

		-- items = nil
		local items = EntityGetFirstComponent( player, "Inventory2Component" )
		-- TODO: 清空物品

		-- perks = nil
		IMPL_remove_all_perks( player )
	end
end

---清空教程所用的所有全局变量
---@return nil
function clean_tutorial_global_variables()
	for _ = 1, 16, 1 do
		GlobalsSetValue( "TUTORIAL_VARIABLE_" .. _, "" )
	end
end

---获取当前教学章节与关卡
---@return string chapter, string level
function get_chapter_and_level()
	local chapter = GlobalsGetValue( "TUTORIAL_CHAPTER" , "0") or "0"
	local level = GlobalsGetValue( "TUTORIAL_LEVEL" , "0") or "0"

	return chapter, level
end

---设当前教学章节与关卡为 chapter 与 level
---@param chapter string
---@param level string
---@return nil
function set_chapter_and_level( chapter, level )
	GlobalsSetValue( "TUTORIAL_CHAPTER" , chapter )
	GlobalsSetValue( "TUTORIAL_LEVEL" , level )
end

---加载关卡初始脚本
---@param chapter string
---@param level string
---@return nil
function load_starting_lua( chapter, level )
	local info = find_level_info_from_table( chapter, level )
	if ( info ) then
		if ( info.starting_lua ) then
			dofile_once( info.starting_lua )
		end
	end
end

---加载世界
---@return nil
function load_world() -- //TODO: 似乎不对? 后续再改改
	local chapter, level = get_chapter_and_level()
	BiomeMapLoad_KeepPlayer( mod_path .. "biome_impl/biome_map_tutorial.lua", mod_path .. "biome/tutorial/" .. chapter .. "/" .. level .. "/_pixel_scenes.xml" )

	load_starting_lua( chapter, level )
end

---加载教学
---@param chapter string
---@param level string
---@return nil
function load_tutorial( chapter, level )
	clean_all()
	clean_tutorial_global_variables()

	delete_other_entities()
	teleport_players( 0, 0 )

	set_chapter_and_level( chapter, level )

	load_world()
	EntityLoad( "data/entities/particles/supernova.xml", 0, 0 )

	GamePrintImportant( "教学 " .. chapter .. "-" .. level .. " 已加载！" )
end

---重置教学
---@return nil
function reset_world()
	clean_all()
	clean_tutorial_global_variables()

	delete_other_entities()
	teleport_players( 0, 0 )

	local chapter, level = get_chapter_and_level()

	load_world()
	EntityLoad( "data/entities/particles/supernova.xml", 0, 0 )

	GamePrintImportant( "教学 " .. chapter .. "-" .. level .. " 已加载！" )
end
