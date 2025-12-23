local path = jit.util.funcinfo( setfenv( 1, getfenv() ) ).source:match( "^.*/" )

local pattern_effect_filepath = "data/poof/effect[%s].xml"
local pattern_effect_file_content =[[
<Entity>
	<GameEffectComponent
		effect="POLYMORPH"
        frames="1"
        polymorph_target="%s">
	</GameEffectComponent>
</Entity>
]]

local blank_entity = path .. "blank_entity.xml"
local duration_long = 99999999

local poof = {}

function poof.polymorph( entity_id, target, duration )
	target = target or blank_entity

	local effect_filepath = pattern_effect_filepath:format( target:gsub( "/", "." ) )
	if not ModDoesFileExist( effect_filepath ) then
		local file_content = pattern_effect_file_content:format( target )
		;( poof.ModTextFileSetContent or ModTextFileSetContent )( effect_filepath, file_content )
	end

	local effect = LoadGameEffectEntityTo( entity_id, effect_filepath )
	local effect_comp = EntityGetFirstComponentIncludingDisabled( effect, "GameEffectComponent" )

	if duration then
		if duration == -1 then
			duration = duration_long
		end
		ComponentSetValue2( effect_comp, "frames", duration )
	else
		ComponentSetValue2( effect_comp, "frames", 2 )
		EntityAddComponent2( effect, "LifetimeComponent", { lifetime = 1 } )
	end

	return effect_comp
end

function poof.unpolymorph( entity_id )
	local effect_comp = GameGetGameEffect( entity_id, "POLYMORPH" )
	if not effect_comp then return end

	ComponentSetValue2( effect_comp, "frames", 1 )
end

function poof.permanentize( entity_id )
	local effect_comp = GameGetGameEffect( entity_id, "POLYMORPH" )
	if not effect_comp then return end

	EntityRemoveFromParent( ComponentGetEntity( effect_comp ) )
end

function poof.dump( entity_id )
	local effect_comp = poof.polymorph( entity_id, nil, 1 )
	return ComponentGetValue2( effect_comp, "mSerializedData" )
end

function poof.load( entity_id, data )
	local effect_comp = poof.polymorph( entity_id, nil, 1 )
	ComponentSetValue2( effect_comp, "mSerializedData", data )
end

do
	local filepath_pattern = path .. "hide_with_tag/%s[%s].xml"
	local file_pattern = [[<Entity name="%s" tags="%s" />]]
	function poof.hide( entity_id, name_after_hide, tag_after_hide )
		name_after_hide = name_after_hide or ""
		tag_after_hide = tag_after_hide or ""

		local target = filepath_pattern:format( name_after_hide, tag_after_hide:gsub( ",", "|" ) )

		if not ModTextFileGetContent( target ) then
			local target_content = file_pattern:format( name_after_hide, tag_after_hide )
			;( poof.ModTextFileSetContent or ModTextFileSetContent )( target, target_content )
		end

		poof.polymorph( entity_id, target, duration_long )
	end
end

return poof
