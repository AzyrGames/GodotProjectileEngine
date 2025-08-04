@icon("uid://b6wnbpajc3guu")
extends PatternComposerComponent
class_name PCCShape2D


enum ShapeSampleMethod {
	## Random sample(s) inside a shape.
	INSIDE_RANDOM,
	## Random sample(s) along the perimeter of a shape.
	PERIMETER_RANDOM,
}

@export var shape_2d: Shape2D
@export var shape_sample_method: ShapeSampleMethod

# Precomputed constants
const TAU: float = 2.0 * PI

# Cache variables
var _polygon_rect_cache: Rect2 = Rect2()
var _polygon_points_cache: PackedVector2Array = PackedVector2Array()
var _perimeter_lengths_cache: PackedFloat32Array = PackedFloat32Array()
var _total_perimeter_cache: float = 0.0

func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData],
	_pattern_composer_context: PatternComposerContext
	) -> Array:
	_new_pattern_composer_pack.clear()
	for _pattern_composer_data: PatternComposerData in _pattern_composer_pack:
		_new_pattern_composer_data = _pattern_composer_data.duplicate()
		match shape_sample_method:
			ShapeSampleMethod.INSIDE_RANDOM:
				_new_pattern_composer_data.position = get_random_point_in_shape(shape_2d) \
					+ _pattern_composer_data.position
			ShapeSampleMethod.PERIMETER_RANDOM:
				_new_pattern_composer_data.position = get_random_point_along_shape(shape_2d) \
					+ _pattern_composer_data.position
		_new_pattern_composer_pack.append(_new_pattern_composer_data)

	return _new_pattern_composer_pack

#region Random Point Inside Shape
## Generating a random point inside a Shape2D.
func get_random_point_in_shape(shape: Shape2D) -> Vector2:
	if shape == null:
		push_warning("Null shape provided")
		return Vector2.ZERO

	if shape is CircleShape2D:
		return _get_random_point_in_circle(shape as CircleShape2D)
	elif shape is RectangleShape2D:
		return _get_random_point_in_rectangle(shape as RectangleShape2D)
	elif shape is CapsuleShape2D:
		return _get_random_point_in_capsule(shape as CapsuleShape2D)
	elif shape is ConvexPolygonShape2D:
		return _get_random_point_in_convex_polygon(shape as ConvexPolygonShape2D)
	else:
		push_warning("Unsupported shape type: %s" % str(shape))
		return Vector2.ZERO

func _get_random_point_in_circle(circle: CircleShape2D) -> Vector2:
	var radius: float = circle.radius
	var angle: float = randf() * TAU
	var r: float = radius * sqrt(randf())
	return Vector2(r * cos(angle), r * sin(angle))

func _get_random_point_in_rectangle(rect: RectangleShape2D) -> Vector2:
	var half_size: Vector2 = rect.size * 0.5
	return Vector2(
		randf_range(-half_size.x, half_size.x),
		randf_range(-half_size.y, half_size.y)
	)

func _get_random_point_in_capsule(capsule: CapsuleShape2D) -> Vector2:
	var radius: float = capsule.radius
	var half_height: float = capsule.height * 0.5
	var rect_area: float = capsule.height * 2.0 * radius
	var total_area: float = rect_area + PI * radius * radius

	if randf() * total_area < rect_area:
		return Vector2(
			randf_range(-radius, radius),
			randf_range(-half_height, half_height)
		)
	else:
		var is_top: bool = randf() < 0.5
		var center_y: float = half_height if is_top else -half_height
		var angle: float = randf() * PI
		var r: float = radius * sqrt(randf())
		var offset: Vector2 = Vector2(r * cos(angle), r * sin(angle))
		return Vector2(offset.x, center_y + (offset.y if is_top else -offset.y))

func _get_random_point_in_convex_polygon(polygon: ConvexPolygonShape2D) -> Vector2:
	var points: PackedVector2Array = polygon.points
	if points.size() < 3:
		return Vector2.ZERO

	if _polygon_points_cache != points:
		_polygon_points_cache = points
		_polygon_rect_cache = polygon.get_rect().grow(1.0)

	var point: Vector2 = Vector2()
	var safe_counter: int = 1000

	while safe_counter > 0:
		point.x = randf_range(_polygon_rect_cache.position.x, _polygon_rect_cache.end.x)
		point.y = randf_range(_polygon_rect_cache.position.y, _polygon_rect_cache.end.y)
		if _is_point_in_polygon(point, points):
			return point
		safe_counter -= 1

	return Vector2.ZERO

func _is_point_in_polygon(point: Vector2, polygon: PackedVector2Array) -> bool:
	var inside: bool = false
	var count: int = polygon.size()
	if count < 3:
		return false

	for i: int in count:
		var j: int = (i + 1) % count
		var a: Vector2 = polygon[i]
		var b: Vector2 = polygon[j]

		if point == a or point == b:
			return true

		if ((a.y > point.y) != (b.y > point.y)) and \
		   (point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x):
			inside = not inside

	return inside

#endregion



#region Random Point Along Shape
## Get a random point along the perimeter of a Shape2D.
func get_random_point_along_shape(shape: Shape2D) -> Vector2:
	if shape == null:
		push_warning("Null shape provided")
		return Vector2.ZERO

	if shape is CircleShape2D:
		return _get_random_point_along_circle(shape as CircleShape2D)
	elif shape is RectangleShape2D:
		return _get_random_point_along_rectangle(shape as RectangleShape2D)
	elif shape is CapsuleShape2D:
		return _get_random_point_along_capsule(shape as CapsuleShape2D)
	elif shape is ConvexPolygonShape2D:
		return _get_random_point_along_convex_polygon(shape as ConvexPolygonShape2D)
	else:
		push_warning("Unsupported shape type: %s" % str(shape))
		return Vector2.ZERO

func _get_random_point_along_circle(circle: CircleShape2D) -> Vector2:
	var angle: float = randf() * TAU
	return Vector2(
		circle.radius * cos(angle),
		circle.radius * sin(angle)
	)

func _get_random_point_along_rectangle(rect: RectangleShape2D) -> Vector2:
	var half: Vector2 = rect.size * 0.5
	var w: float = rect.size.x
	var h: float = rect.size.y
	var perimeter: float = 2.0 * (w + h)
	var pos: float = randf() * perimeter

	if pos < w: # Top edge
		return Vector2(lerp(-half.x, half.x, pos / w), half.y)
	pos -= w

	if pos < h: # Right edge
		return Vector2(half.x, lerp(half.y, -half.y, pos / h))
	pos -= h

	if pos < w: # Bottom edge
		return Vector2(lerp(half.x, -half.x, pos / w), -half.y)
	pos -= w

	# Left edge
	return Vector2(-half.x, lerp(-half.y, half.y, pos / h))

func _get_random_point_along_capsule(capsule: CapsuleShape2D) -> Vector2:
	var radius: float = capsule.radius
	var height: float = capsule.height
	var half_height: float = height * 0.5
	var straight_len: float = height
	var semicircle_len: float = PI * radius
	var perimeter: float = 2.0 * (straight_len + semicircle_len)
	var pos: float = randf() * perimeter

	if pos < semicircle_len: # Top semicircle (180° arc)
		var angle: float = lerp(PI, 0.0, pos / semicircle_len)
		return Vector2(
			radius * cos(angle),
			- (half_height + radius * sin(angle))
		)
	pos -= semicircle_len

	if pos < straight_len: # Right straight segment
		return Vector2(radius, -half_height + pos)
	pos -= straight_len

	if pos < semicircle_len: # Bottom semicircle (180° arc)
		var angle: float = lerp(0.0, PI, pos / semicircle_len)
		return Vector2(
			radius * cos(angle),
			half_height + radius * sin(angle)
		)
	pos -= semicircle_len

	# Left straight segment
	return Vector2(-radius, half_height - pos)

func _get_random_point_along_convex_polygon(polygon: ConvexPolygonShape2D) -> Vector2:
	var points: PackedVector2Array = polygon.points
	var count: int = points.size()

	if count < 2:
		return Vector2.ZERO

	if _polygon_points_cache != points:
		_polygon_points_cache = points
		_perimeter_lengths_cache = PackedFloat32Array()
		_total_perimeter_cache = 0.0

		for i: int in count:
			var j: int = (i + 1) % count
			var len: float = points[i].distance_to(points[j])
			_perimeter_lengths_cache.append(len)
			_total_perimeter_cache += len

	var target: float = randf() * _total_perimeter_cache
	var accumulated: float = 0.0

	for i: int in count:
		var edge_len: float = _perimeter_lengths_cache[i]
		if target <= accumulated + edge_len:
			var t: float = (target - accumulated) / edge_len
			return points[i].lerp(points[(i + 1) % count], t)
		accumulated += edge_len

	return points[0]


#endregion
