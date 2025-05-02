## Bullet Pattern Component Base

extends BPCBase
class_name BPCCustomShape


@export var shape_path : Curve2D

enum PointType {
	POINT,
	BAKED_POINT,
}

@export var point_type : PointType

## Point per spawn, -1 to get all point with Point Type
## 0 to return Original Bullet Instance
@export var point_per_spawn : int = 1

@export var reset_per_spawn : bool = false

var _curve_point_idx : int = 0

func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	var _new_bullet_packs := []
	for instance : Dictionary in pattern_packs:
		_new_bullet_packs.append_array(get_custom_shape_points(instance))
		pass

	return _new_bullet_packs

func get_custom_shape_points(_instance: Dictionary) -> Array:
	var _new_pack : Array = []
	match point_type:
		PointType.POINT:
			if point_per_spawn == 0:
				var _new_instance := _instance.duplicate()
				_new_pack.append(_new_instance)
			elif point_per_spawn < 0:
				for i in range(shape_path.point_count):
					var _new_instance := _instance.duplicate()
					_new_instance.position = shape_path.get_point_position(i)
					_new_pack.append(_new_instance)
			else:
				for i in range(point_per_spawn):
					var _new_instance := _instance.duplicate()
					_new_instance.position = shape_path.get_point_position(_curve_point_idx)
					_new_pack.append(_new_instance)
					_curve_point_idx += 1
					if _curve_point_idx >= shape_path.point_count:
						_curve_point_idx = 0
		PointType.BAKED_POINT:
			if point_per_spawn == 0:
				var _new_instance := _instance.duplicate()
				_new_pack.append(_new_instance)
			elif point_per_spawn < 0:
				for baked_point in shape_path.get_baked_points():
					var _new_instance := _instance.duplicate()
					_new_instance.position = baked_point
					_new_pack.append(_new_instance)
			else:
				var _baked_point := shape_path.get_baked_points()
				for i in range(point_per_spawn):
					var _new_instance := _instance.duplicate()
					_new_instance.position = _baked_point[_curve_point_idx]
					_new_pack.append(_new_instance)
					_curve_point_idx += 1
					if _curve_point_idx >= _baked_point.size():
						_curve_point_idx = 0

	if reset_per_spawn:
		_curve_point_idx = 0

	return _new_pack


