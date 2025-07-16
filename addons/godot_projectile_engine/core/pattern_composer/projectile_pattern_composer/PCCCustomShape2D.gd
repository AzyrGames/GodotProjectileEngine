## Projectile Pattern Component

extends PatternComposerComponent
class_name PCCCustomShape2D


@export var shape_path : Curve2D

enum PointType {
	POINT,
	BAKED_POINT,
}

@export var point_type : PointType

## Point per spawn, -1 to get all point with Point Type
## 0 to return Original Projectile Instance
@export var point_per_spawn : int = 1

@export var reset_per_spawn : bool = false

var _curve_point_idx : int = 0

func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	var _new_projectile_packs : Array[PatternComposerData] = []
	if !shape_path:
		return pattern_composer_pack
	for pattern_data : PatternComposerData in pattern_composer_pack:
		_new_projectile_packs.append_array(get_custom_shape_points(pattern_data))
		pass

	return _new_projectile_packs

func get_custom_shape_points(pattern_data: PatternComposerData) -> Array[PatternComposerData]:
	var _new_pack : Array[PatternComposerData] = []
	match point_type:
		PointType.POINT:
			if point_per_spawn == 0:
				var _new_pattern_data := PatternComposerData.new()
				_new_pattern_data.position = pattern_data.position
				_new_pattern_data.direction = pattern_data.direction
				_new_pattern_data.rotation = pattern_data.rotation
				_new_pattern_data.speed_mod = pattern_data.speed_mod
				_new_pack.append(_new_pattern_data)
			elif point_per_spawn < 0:
				for i in range(shape_path.point_count):
					var _new_pattern_data := PatternComposerData.new()
					_new_pattern_data.position = pattern_data.position
					_new_pattern_data.direction = pattern_data.direction
					_new_pattern_data.rotation = pattern_data.rotation
					_new_pattern_data.speed_mod = pattern_data.speed_mod
					_new_pattern_data.position = shape_path.get_point_position(i) + pattern_data.position
					_new_pack.append(_new_pattern_data)
			else:
				for i in range(point_per_spawn):
					var _new_pattern_data := PatternComposerData.new()
					_new_pattern_data.position = pattern_data.position
					_new_pattern_data.direction = pattern_data.direction
					_new_pattern_data.rotation = pattern_data.rotation
					_new_pattern_data.speed_mod = pattern_data.speed_mod
					_new_pattern_data.position = shape_path.get_point_position(_curve_point_idx) + pattern_data.position
					_new_pack.append(_new_pattern_data)
					_curve_point_idx += 1
					if _curve_point_idx >= shape_path.point_count:
						_curve_point_idx = 0
		PointType.BAKED_POINT:
			if point_per_spawn == 0:
				var _new_pattern_data := PatternComposerData.new()
				_new_pattern_data.position = pattern_data.position
				_new_pattern_data.direction = pattern_data.direction
				_new_pattern_data.rotation = pattern_data.rotation
				_new_pattern_data.speed_mod = pattern_data.speed_mod
				_new_pack.append(_new_pattern_data)
			elif point_per_spawn < 0:
				for baked_point in shape_path.get_baked_points():
					var _new_pattern_data := PatternComposerData.new()
					_new_pattern_data.position = pattern_data.position
					_new_pattern_data.direction = pattern_data.direction
					_new_pattern_data.rotation = pattern_data.rotation
					_new_pattern_data.speed_mod = pattern_data.speed_mod
					_new_pattern_data.position = baked_point + pattern_data.position
					_new_pack.append(_new_pattern_data)
			else:
				var _baked_point := shape_path.get_baked_points()
				for i in range(point_per_spawn):
					var _new_pattern_data := PatternComposerData.new()
					_new_pattern_data.position = pattern_data.position
					_new_pattern_data.direction = pattern_data.direction
					_new_pattern_data.rotation = pattern_data.rotation
					_new_pattern_data.speed_mod = pattern_data.speed_mod
					_new_pattern_data.position = _baked_point[_curve_point_idx] + pattern_data.position
					_new_pack.append(_new_pattern_data)
					_curve_point_idx += 1
					if _curve_point_idx >= _baked_point.size():
						_curve_point_idx = 0

	if reset_per_spawn:
		_curve_point_idx = 0

	return _new_pack
