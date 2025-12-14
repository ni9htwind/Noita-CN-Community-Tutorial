local vec2 = {}

function vec2.clone( vec )
	return { vec[1], vec[2] }
end

function vec2.add( vec_a, vec_b )
	return { vec_a[1] + vec_b[1], vec_a[2] + vec_b[2] }
end

function vec2.sub( vec_a, vec_b )
	return { vec_a[1] - vec_b[1], vec_a[2] - vec_b[2] }
end

function vec2.mult( vec, a )
	return { vec[1] * a, vec[2] * a }
end

function vec2.len2( vec )
	return vec[1] ^ 2 + vec[2] ^ 2
end

function vec2.len( vec )
	return math.sqrt( vec2.len2( vec ) )
end

function vec2.normalize( vec )
	if vec[1] == 0 and vec[2] == 0 then
		return {0,0}
	end

	local len = vec2.len( vec )
	return { vec[1] / len, vec[2] / len }
end

function vec2.distance( vec_a, vec_b )
	return vec2.len( vec2.sub( vec_a, vec_b ) )
end

return vec2
