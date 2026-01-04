dofile_once( "data/scripts/lib/utilities.lua" )

local mod_prefix = "community_tutorial."
local mod_path = "mods/community_tutorial/"

local font = "mods/community_tutorial/files/level_api/dummy_target/font.xml"

local function center_text( text, font )
	local gui = GuiCreate()
	local result = GuiGetTextDimensions( gui, text, 1, 0, font, true ) / 2
	GuiDestroy( gui )
	return result
end

local inf = 1 / 0
local threshold = 10 ^ 10
local function format_damage( damage )
	if damage == inf then
		return "i"
	end
	damage = damage * 25
	if damage > threshold or -damage > threshold then
		return string.format( "%.10e", damage )
	end
	return string.format( "%.2f", damage )
end

local function set_text( entity_id, tag_sprite, value, offset_y )
	local child_id = ( EntityGetAllChildren( entity_id, mod_prefix .. "dummy_target_child" ) or {} )[1]
	if not EntityGetIsAlive( child_id ) then return end

	local sprite_comp = EntityGetFirstComponent( child_id, "SpriteComponent", tag_sprite )
	if not sprite_comp then return end

	local text = format_damage( value )
	ComponentSetValue2( sprite_comp, "offset_x", center_text( text, font ) )
	ComponentSetValue2( sprite_comp, "text", text )
	EntityRefreshSprite( entity_id, sprite_comp )
end

function damage_received( damage, message, entity_thats_responsible, is_fatal )
	local entity_id = GetUpdatedEntityID()
	local dm_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )

	local last_frame_damage_comp = get_variable_storage_component( entity_id, mod_prefix .. "last_frame_damage" )

	local last_frame_damage
	if GameGetFrameNum() - ComponentGetValue2( dm_comp, "mLastDamageFrame" ) < 60 then
		last_frame_damage = ComponentGetValue2( last_frame_damage_comp, "value_float" )
	else
		last_frame_damage = 0
	end

	last_frame_damage = last_frame_damage + damage

	ComponentSetValue2( last_frame_damage_comp, "value_float", last_frame_damage )
	set_text( entity_id, mod_prefix .. "last_frame_damage", last_frame_damage )


	local cd_comp = EntityGetFirstComponent( entity_id, "CharacterDataComponent" )
	ComponentSetValue2( cd_comp, "mVelocity", 0, 0 )
end
