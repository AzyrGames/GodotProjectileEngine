@icon("uid://cq7tsfcj4e8tu")
extends PatternComposerComponent
class_name PCCCustomShape2D

enum ShapeSampleMethod {
	POINTS,
	BAKED_POINTS,
	INSIDE_RANDOM,
	PERIMETER_RANDOM,
	PERIMETER_UNIFORM_DISTANCE,
}

@export var shape_path: Curve2D
@export var shape_sample_method: ShapeSampleMethod = ShapeSampleMethod.POINTS
@export var point_per_spawn: int = 1
@export var reset_per_spawn: bool = false
@export var uniform_distance: float = 10.0:  # Distance between points for uniform sampling
	set(value):
		uniform_distance = value
		_uniform_points_cache.clear()
		_uniform_distance_last = -1.0
		_point_idx = 0

var _point_idx: int = 0
var _baked_points_cache: PackedVector2Array
var _polygon_cache: PackedVector2Array
var _total_perimeter_cache: float = 0.0
var _perimeter_lengths_cache: PackedFloat32Array
var _uniform_points_cache: PackedVector2Array
var _uniform_distance_last: float = -1.0

var _new_sub_pattern_composer_data: Array[PatternComposerData]


func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData],
	_pattern_composer_context: PatternComposerContext
) -> Array[PatternComposerData]:
	_new_pattern_composer_pack.clear()
	
	if !shape_path:
		return _pattern_composer_pack
		
	for _pattern_composer_data in _pattern_composer_pack:
		_new_pattern_composer_pack.append_array(_get_shape_points(_pattern_composer_data))
	
	if reset_per_spawn:
		_point_idx = 0
		
	return _new_pattern_composer_pack

func _get_shape_points(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data.clear()
	
	if point_per_spawn == 0:
		var new_data := _pattern_composer_data.duplicate()
		_new_sub_pattern_composer_data.append(new_data)
		return _new_sub_pattern_composer_data
	
	match shape_sample_method:
		ShapeSampleMethod.POINTS:
			_new_sub_pattern_composer_data = _get_control_points(_pattern_composer_data)
		ShapeSampleMethod.BAKED_POINTS:
			_new_sub_pattern_composer_data = _get_baked_points(_pattern_composer_data)
		ShapeSampleMethod.INSIDE_RANDOM:
			_new_sub_pattern_composer_data = _get_random_inside_points(_pattern_composer_data)
		ShapeSampleMethod.PERIMETER_RANDOM:
			_new_sub_pattern_composer_data = _get_random_perimeter_points(_pattern_composer_data)
		ShapeSampleMethod.PERIMETER_UNIFORM_DISTANCE:
			_new_sub_pattern_composer_data = _get_uniform_perimeter_points(_pattern_composer_data)
	
	return _new_sub_pattern_composer_data

func _get_control_points(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data.clear
	var point_count = shape_path.point_count
	
	if point_per_spawn < 0:
		for i in point_count:
			var new_data := _pattern_composer_data.duplicate()
			new_data.position += shape_path.get_point_position(i)
			_new_sub_pattern_composer_data.append(new_data)
	else:
		for i in point_per_spawn:
			var new_data := _pattern_composer_data.duplicate()
			new_data.position += shape_path.get_point_position(_point_idx)
			_new_sub_pattern_composer_data.append(new_data)
			_point_idx = (_point_idx + 1) % point_count
	
	return _new_sub_pattern_composer_data

func _get_baked_points(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data
	var baked_points = shape_path.get_baked_points()
	
	if point_per_spawn < 0:
		for point in baked_points:
			var new_data := _pattern_composer_data.duplicate()
			new_data.position += point
			_new_sub_pattern_composer_data.append(new_data)
	else:
		for i in point_per_spawn:
			var new_data := _pattern_composer_data.duplicate()
			new_data.position += baked_points[_point_idx]
			_new_sub_pattern_composer_data.append(new_data)
			_point_idx = (_point_idx + 1) % baked_points.size()
	
	return _new_sub_pattern_composer_data

func _get_random_inside_points(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data
	var count = point_per_spawn if point_per_spawn > 0 else 1
	
	for i in count:
		var new_data := _pattern_composer_data.duplicate()
		new_data.position += get_random_point_inside()
		_new_sub_pattern_composer_data.append(new_data)
	
	return _new_sub_pattern_composer_data

func _get_random_perimeter_points(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data
	var count = point_per_spawn if point_per_spawn > 0 else 1
	
	for i in count:
		var new_data := _pattern_composer_data.duplicate()
		new_data.position += get_random_point_along_perimeter()
		_new_sub_pattern_composer_data.append(new_data)
	
	return _new_sub_pattern_composer_data

func get_random_point_inside() -> Vector2:
	if !shape_path:
		return Vector2.ZERO
	
	_ensure_baked_points_cache()
	
	if _polygon_cache.size() < 3:
		return Vector2.ZERO
	
	# Create bounding rect
	var rect = Rect2()
	for point in _polygon_cache:
		rect = rect.expand(point)
	rect = rect.grow(1.0)
	
	# Rejection sampling
	var point: Vector2
	var safe_counter = 1000
	
	while safe_counter > 0:
		point.x = randf_range(rect.position.x, rect.end.x)
		point.y = randf_range(rect.position.y, rect.end.y)
		if _is_point_in_polygon(point, _polygon_cache):
			return point
		safe_counter -= 1
	
	return Vector2.ZERO

func get_random_point_along_perimeter() -> Vector2:
	if !shape_path:
		return Vector2.ZERO
	
	_ensure_baked_points_cache()
	
	if _polygon_cache.size() < 2:
		return Vector2.ZERO
	
	# Cache perimeter calculations if needed
	if _perimeter_lengths_cache.size() != _polygon_cache.size():
		_perimeter_lengths_cache = PackedFloat32Array()
		_total_perimeter_cache = 0.0
		
		for i in _polygon_cache.size():
			var j = (i + 1) % _polygon_cache.size()
			var len = _polygon_cache[i].distance_to(_polygon_cache[j])
			_perimeter_lengths_cache.append(len)
			_total_perimeter_cache += len
	
	var target = randf() * _total_perimeter_cache
	var accumulated: float = 0.0
	
	for i in _polygon_cache.size():
		var edge_len = _perimeter_lengths_cache[i]
		if target <= accumulated + edge_len:
			var t = (target - accumulated) / edge_len
			var start = _polygon_cache[i]
			var end = _polygon_cache[(i + 1) % _polygon_cache.size()]
			return start.lerp(end, t)
		accumulated += edge_len
	
	return _polygon_cache[0]

func _ensure_baked_points_cache():
	if _baked_points_cache.is_empty():
		_baked_points_cache = shape_path.get_baked_points()
		_polygon_cache = _baked_points_cache

func _is_point_in_polygon(point: Vector2, polygon: PackedVector2Array) -> bool:
	var inside = false
	var count = polygon.size()
	if count < 3:
		return false
	
	for i in count:
		var j = (i + 1) % count
		var a = polygon[i]
		var b = polygon[j]
		
		if point == a or point == b:
			return true
		
		if ((a.y > point.y) != (b.y > point.y)) and \
		   (point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x):
			inside = not inside
	
	return inside


func _get_uniform_perimeter_points(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data
	var uniform_points = _get_uniform_distance_points()
	
	if point_per_spawn < 0:
		for point in uniform_points:
			var new_data := _pattern_composer_data.duplicate()
			new_data.position += point
			_new_sub_pattern_composer_data.append(new_data)
	else:
		for i in point_per_spawn:
			var new_data := _pattern_composer_data.duplicate()
			new_data.position += uniform_points[_point_idx]
			_new_sub_pattern_composer_data.append(new_data)
			_point_idx = (_point_idx + 1) % uniform_points.size()
	
	return _new_sub_pattern_composer_data

func _get_uniform_distance_points() -> PackedVector2Array:
	if !shape_path || uniform_distance <= 0:
		return PackedVector2Array()
	
	# Return cached points if parameters haven't changed
	if _uniform_distance_last == uniform_distance && !_uniform_points_cache.is_empty():
		return _uniform_points_cache
	
	_ensure_baked_points_cache()
	_uniform_distance_last = uniform_distance
	_uniform_points_cache = PackedVector2Array()
	
	if _polygon_cache.size() < 2:
		return _uniform_points_cache
	
	# Calculate total perimeter and segment lengths
	var total_length := 0.0
	var segment_lengths := PackedFloat32Array()
	var segment_vectors := PackedVector2Array()
	
	for i in _polygon_cache.size():
		var j := (i + 1) % _polygon_cache.size()
		var start := _polygon_cache[i]
		var end := _polygon_cache[j]
		var vec := end - start
		var length := vec.length()
		
		segment_lengths.append(length)
		segment_vectors.append(vec)
		total_length += length
	
	if total_length <= 0:
		return _uniform_points_cache
	
	# Generate points at uniform distances
	var current_distance := 0.0
	var target_distance := 0.0
	var safety_counter := 1000  # Prevent infinite loops
	
	while target_distance < total_length && safety_counter > 0:
		safety_counter -= 1
		
		# Find which segment contains our target distance
		var accumulated := 0.0
		var segment_index := 0
		var segment_start := Vector2()
		var segment_vec := Vector2()
		var segment_len := 0.0
		
		for i in _polygon_cache.size():
			if target_distance <= accumulated + segment_lengths[i]:
				segment_index = i
				segment_start = _polygon_cache[i]
				segment_vec = segment_vectors[i]
				segment_len = segment_lengths[i]
				break
			accumulated += segment_lengths[i]
		
		# Calculate position along segment without lerp
		var segment_progress := target_distance - accumulated
		var t := segment_progress / segment_len
		t = clamp(t, 0.0, 1.0)
		
		# point = start + (vec * t)
		var point := segment_start + (segment_vec * t)
		_uniform_points_cache.append(point)
		
		# Move to next target distance
		target_distance += uniform_distance
	
	# Ensure the shape is properly closed if it's a loop
	if _polygon_cache.size() > 2:
		var first_point := _polygon_cache[0]
		var last_point := _polygon_cache[_polygon_cache.size() - 1]
		if first_point.distance_to(last_point) < 0.001:
			_uniform_points_cache.append(first_point)
	
	return _uniform_points_cache
