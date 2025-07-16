extends PatternComposerComponent
class_name PCCShape2D

@export var shape_2d: Shape2D
# @export var navigation_map : NavigationMesh

func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	var _new_projectile_packs : Array[PatternComposerData] = []
	for pattern_data : PatternComposerData in pattern_composer_pack:
		var _new_pattern_data := PatternComposerData.new()
		_new_pattern_data.position = pattern_data.position
		_new_pattern_data.direction = pattern_data.direction
		_new_pattern_data.rotation = pattern_data.rotation
		_new_pattern_data.speed_mod = pattern_data.speed_mod
		
		_new_pattern_data.position = get_random_point_in_shape(shape_2d, _new_pattern_data.position) + pattern_data.position
		_new_projectile_packs.append(_new_pattern_data)

	return _new_projectile_packs

func get_random_point_in_shape(shape: Shape2D, origin_pos: Vector2) -> Vector2:
	if shape is CircleShape2D:
		var radius = shape.radius
		var angle = randf() * TAU
		var r = radius * sqrt(randf())
		return Vector2(r * cos(angle), r * sin(angle))
	
	elif shape is RectangleShape2D:
		var extents = shape.size / 2.0
		return Vector2(randf_range(-extents.x, extents.x), randf_range(-extents.y, extents.y))
	
	elif shape is CapsuleShape2D:
		var radius = shape.radius
		var height = shape.height
		var total_area = height * 2 * radius + PI * radius * radius
		var rand_val = randf() * total_area
		
		if rand_val < height * 2 * radius:
			# Generate in rectangle part
			var x = randf_range(-radius, radius)
			var y = randf_range(-height/2.0, height/2.0)
			return Vector2(x, y)
		else:
			# Generate in semicircle part
			var center = Vector2(0, height/2.0) if (randf() < 0.5) else Vector2(0, -height/2.0)
			while true:
				var angle = randf() * TAU
				var r = radius * sqrt(randf())
				var offset = Vector2(r * cos(angle), r * sin(angle))
				var candidate = center + offset
				if (center.y > 0 and candidate.y >= center.y) or (center.y < 0 and candidate.y <= center.y):
					return candidate
	
	elif shape is ConvexPolygonShape2D :
		var points = shape.points
		if points.size() < 3:
			return origin_pos
		var rect = shape.get_rect()
		var _while_false_safe : int = 0
		while _while_false_safe < 1000:
			var x = randf_range(rect.position.x, rect.end.x)
			var y = randf_range(rect.position.y, rect.end.y)
			var point = Vector2(x, y)
			if _is_point_in_polygon(point, points):
				return point
			_while_false_safe += 1
		return origin_pos
	else:
		print_debug(shape, " is not a supported Shape2D! Return original projectile instance position")
		return origin_pos

	return origin_pos

func _is_point_in_polygon(point: Vector2, polygon: PackedVector2Array) -> bool:
	var inside = false
	var length = polygon.size()
	if length < 3:
		return false
	
	for i in length:
		var j = (i + 1) % length
		var vi = polygon[i]
		var vj = polygon[j]
		
		# Check if point is on vertex
		if point == vi or point == vj:
			return true
		
		# Check intersection with edge
		if ((vi.y > point.y) != (vj.y > point.y)) and \
			(point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x):
			inside = not inside
	
	return inside
