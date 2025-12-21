local entity_id = GetUpdatedEntityID()

local cd_comp = EntityGetFirstComponent( entity_id, "CharacterDataComponent" )
ComponentSetValue2( cd_comp, "mVelocity", 0, 0 )

local child_id = EntityGetAllChildren( entity_id )[1]
local it_comp = EntityGetFirstComponent( child_id, "InheritTransformComponent" )
if it_comp then
	EntitySetComponentIsEnabled( child_id, it_comp, false )
end

local x, y = EntityGetTransform( entity_id )
local child_x, child_y = EntityGetTransform( child_id )
if child_x == 0 and child_y == 0 then
	EntitySetTransform( child_id, x, y )
	child_x, child_y = x, y
end

local distance2 = ( x - child_x ) ^ 2 + ( y - child_y ) ^ 2

if distance2 < 256 then return end

local d2_comp, time_still_comp
do
	local var_comps = EntityGetComponent( entity_id, "VariableStorageComponent", "invincible" )
	d2_comp, time_still_comp = var_comps[1], var_comps[2]
end

local last_distance2 = ComponentGetValue2( d2_comp, "value_float" )
if last_distance2 == distance2 then
	ComponentSetValue2( time_still_comp, "value_int", ComponentGetValue2( time_still_comp, "value_int" ) + 1 )
end
ComponentSetValue2( d2_comp, "value_float", distance2 )

local function teleport( entity_id, from_x, from_y, to_x, to_y)
	EntitySetTransform( entity_id, to_x, to_y )
	EntityLoad("data/entities/particles/teleportation_source.xml", from_x, from_y )
	EntityLoad("data/entities/particles/teleportation_target.xml", to_x, to_y )
	GamePlaySound("data/audio/Desktop/misc.bank","game_effect/teleport/tick", to_x, to_y )
end

if ComponentGetValue2( time_still_comp, "value_int" ) >= 120 then
	ComponentSetValue2( time_still_comp, "value_int", 0 )
	teleport( entity_id, x, y, child_x, child_y )
end
