local whoosh = {
	inited = false,
	points = nil,
	dest_point_index = nil,
	step_length = nil,
	smoothe_coeff = nil,
	pos_getter = function()
		return { GameGetCameraPos() }
	end,
	pos_setter = function( pos )
		GameSetCameraPos( unpack( pos ) )
	end,
}

local path = jit.util.funcinfo( setfenv( 1, getfenv() ) ).source:match( "^.*/" )
local vec2 = dofile_once( path .. "vec2.lua" )

function whoosh:init( points, step_length, smoothe_coeff, move_fn )
	self.points = points
	self.dest_point_index = 1
	self.step_length = self.step_length or 6
	self.smoothe_coeff = self.smoothe_coeff or 20

	self.inited = true
end

function whoosh:update()
	if not self.inited then
		print_error( "Used without init" )
		return nil
	end

	local pos = self.pos_getter()
	local dest_point = self.points[ self.dest_point_index ]
	if not dest_point then
		self.inited = false
		return nil
	end

	local _step_length = self.step_length

	local distance_left = vec2.distance( pos, dest_point )
	if dest_point[3] and distance_left <= self.step_length * self.smoothe_coeff then
		_step_length = math.min( _step_length, math.max( distance_left / self.smoothe_coeff, 0.1 ) )
	end

	local from_point = self.points[ self.dest_point_index - 1 ]
	if from_point then
		local distance_traveled = vec2.distance( from_point, pos )
		if from_point[3] and distance_traveled <= self.step_length * self.smoothe_coeff then
			_step_length = math.min( _step_length, math.max( distance_left / self.smoothe_coeff, 0.1 ) )
		end
	end

	local result = self.dest_point_index
	if --[[self.dest_point_index > 1 and ]]distance_left >= _step_length then
		pos = vec2.add( pos, vec2.mult( vec2.normalize( vec2.sub( dest_point, pos ) ), _step_length ) )
	else
		pos = vec2.clone( dest_point )

		if dest_point[3] then
			result = result + 1
			self.time_stayed = ( self.time_stayed or 0 ) + 1
			if self.time_stayed > dest_point[3] then
				self.time_stayed = 0
				self.dest_point_index = self.dest_point_index + 1
			end
		else
			self.dest_point_index = self.dest_point_index + 1
		end
	end

	self.pos_setter( pos )
	return result
end

return whoosh
