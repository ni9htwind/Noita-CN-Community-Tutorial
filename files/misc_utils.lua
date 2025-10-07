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

local function dofile_mask( env )
	local loadonce, loaded = {}, {}
	local mask = {}
	mask.do_mod_appends = function( filepath )
		local appends = {}
		local dofile_backup = _G.dofile
		_G.dofile = function( filepath )
			appends[ #appends + 1 ] = filepath
		end
		do_mod_appends( filepath )
		_G.dofile = dofile_backup

		for _, filepath in ipairs( appends ) do
			mask.dofile( filepath )
		end
	end
	mask.dofile_once = function( filepath )
	    local result
	    local cached = loadonce[ filepath ]
	    if cached ~= nil then
	        result = cached[1]
	    else
	        local f, err = loadfile( filepath )
	        if f == nil then return f, err end
	        setfenv( f, env )
	        result = f()
	        loadonce[ filepath ] = { result }
	        mask.do_mod_appends( filepath )
	    end
	    return result
	end
	mask.dofile = function( filepath )
	    local f = loaded[ filepath ]
	    if f == nil then
	    	local err
	        f, err = loadfile( filepath )
	        if f == nil then return f, err end
	        setfenv( f, env )
	        loaded[ filepath ] = f
	    end
	    local result = f()
	    mask.do_mod_appends( filepath )
	    return result
	end

	return mask
end

function get_globals( filepath )
	local f = loadfile( filepath )
	local e_backup = getfenv( f )

	local e = {}
	local mask = setmetatable( dofile_mask( e ), { __index = _G } )
	setmetatable( e, { __index = mask } )
	setfenv( f, e )()
	setmetatable( e, nil )

	setfenv( f, e_backup )
	return e
end

get_globals = memoize( get_globals )

function dofile_wrapped( filepath )
	local f = loadfile( filepath )
	local e_backup = getfenv( f )
	local e = setmetatable( {}, { __index = e_backup } )
	local result = setfenv( f, e )()
	setfenv( f, e_backup )
	return result
end

dofile_once_wrapped = memoize( dofile_wrapped )