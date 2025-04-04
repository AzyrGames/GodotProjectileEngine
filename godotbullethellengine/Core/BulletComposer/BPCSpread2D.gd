## Bullet Pattern Component Base
extends BPCBase
class_name BPCSpread2D
#@export_group("Spread Properties")


enum SpreadType {
	STRAIGHT,
	ANGLE
}

@export var spread_amount : int = 3
@export var spread_type : SpreadType = SpreadType.STRAIGHT
@export var spread_value : float = 5

func process_pattern(pattern_packs: Array) -> Array:
	var _new_pattern_packs := []
	match spread_type:
		SpreadType.STRAIGHT:
			for instance : Dictionary in pattern_packs:
				_new_pattern_packs.append_array(_add_bullet_straight_spread(instance))
		SpreadType.ANGLE:
			for instance : Dictionary in pattern_packs:
				_new_pattern_packs.append_array(_add_bullet_angle_spread(instance))
	return _new_pattern_packs


func _add_bullet_straight_spread(instance: Dictionary) -> Array:
	var _new_instances : Array = []

	var _half_total_width : float = (spread_amount - 1) * spread_value / 2.0
	var _bullet_position : Vector2 = instance.direction

	for i in range(spread_amount):
		var _new_instance := instance.duplicate()
		var _offset : float = (i * spread_value) - _half_total_width
		var _point : Vector2 = _bullet_position + instance.direction.rotated(deg_to_rad(90)) * _offset

		_new_instance.position = _point

		_new_instances.append(_new_instance)

	return _new_instances

func _add_bullet_angle_spread(instance: Dictionary) -> Array:
	var _new_instances : Array = []

	var _half_total_deg : float = (spread_amount - 1) * spread_value / 2.0

	for i in range(spread_amount):
		var _offset : float = (i * spread_value) - _half_total_deg
		var _direction_vector : Vector2 = deg_to_dir(rad_to_deg(instance.direction.angle()) - _offset)
		var _new_instance := instance.duplicate()

		_new_instance.direction = _direction_vector
	
		_new_instances.append(_new_instance)


	return _new_instances

func deg_to_dir(deg: float) -> Vector2:
	var radian_angle := deg_to_rad(deg)
	var x := cos(radian_angle)
	var y := sin(radian_angle)
	return Vector2(x, y)
