
levels_info = {
	{
		---@type string
		name = "sample: $level_0_0",
		---@type string
		description = "sample: $leveldesc_0_0",
		---@type string
		chapter = "0",
		---@type string
		level = "0",
		---@type string|nil
		starting_lua = "sample_starting_lua.lua",
		---@type string
		map_filename = "sample",
		---@type string
		map_pixel_scenes = "sample_pixel_scenes.xml",
	},
}

---从 levels_info 内通过 chapter 与 level 搜索关卡信息表
---@param chapter string
---@param level string
---@return table|nil
function find_level_info_from_table( chapter, level )
	for _, level_info in ipairs( levels_info ) do
		if ( level_info.chapter == chapter and level_info.level == level ) then
			return level_info
		end
	end

	return nil
end
