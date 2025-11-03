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

local poof = {}

function poof.polymorph( entity_id, duration, into )
	into = into or blank_entity

	local effect_filepath = pattern_effect_filepath:format( into:gsub( "/", "." ) )
	if not ModDoesFileExist( effect_filepath ) then
		local file_content = pattern_effect_file_content:format( into )
		;( poof.ModTextFileSetContent or ModTextFileSetContent )( effect_filepath, file_content )
	end

	local effect = LoadGameEffectEntityTo( entity_id, effect_filepath )
	local effect_comp = EntityGetFirstComponentIncludingDisabled( effect, "GameEffectComponent" )

	if duration then
		ComponentSetValue2( effect_comp, "frames", duration )
	end

	return effect_comp
end

function poof.unpolymorph( entity_id )
	local effect_comp = GameGetGameEffect( entity_id, "POLYMORPH" )
	if not effect_comp then return end

	ComponentSetValue2( effect_comp, "frames", 1 )
end

function poof.dump( entity_id )
	local effect_comp = poof.polymorph( entity_id, 1, nil )
	return ComponentGetValue2( effect_comp, "mSerializedData" )
end

function poof.load( entity_id, data )
	local effect_comp = poof.polymorph( entity_id, 1, nil )
	ComponentSetValue2( effect_comp, "mSerializedData", data )
end

do
	local filepath_pattern = path .. "hide_with_tag/%s[%s].xml"
	local file_pattern = [[<Entity name="%s" tags="%s" />]]
	function poof.hide( entity_id, name_after_hide, tag_after_hide )
		name_after_hide = name_after_hide or ""
		tag_after_hide = tag_after_hide or ""

		local into = filepath_pattern:format( name_after_hide, tag_after_hide:gsub( ",", "|" ) )

		if not ModTextFileGetContent( into ) then
			local into_content = file_pattern:format( name_after_hide, tag_after_hide )
			;( poof.ModTextFileSetContent or ModTextFileSetContent )( into, into_content )
		end

		poof.polymorph( entity_id, 99999999, into )
	end
end

return poof
