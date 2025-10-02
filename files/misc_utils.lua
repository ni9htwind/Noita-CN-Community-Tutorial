local mod_id = "community_tutorial"

local key_prefix = "$" .. mod_id .. "_"
function wrap_key( key )
	return key_prefix .. key
end

function optional_call( f, ... )
	if f then return f( ... ) end
end

function memoize( f )
	return setmetatable( {}, {
		__call = function( self, arg )
			local cache = self[ arg ]
			if cache ~= nil then return cache end
			local result = f( arg )
			self[ arg ] = result
			return result
		end,
	} )
end

local loadfile_memoized = memoize( loadfile )

local function dofile_wrapped( filepath, environment )
	local f = loadfile_memoized( filepath )
	local e = environment or {}
	setfenv( f, e )()
	return e
end

function get_globals( filepath )
	local g = _G
	local captured_globals = {}
	local mt = {
		__index = g,
		__newindex = function( e, k, v )
			rawset( e, k, v )
			captured_globals[ k ] = v
		end,
	}
	return dofile_wrapped( filepath, setmetatable( {}, mt ) )
end