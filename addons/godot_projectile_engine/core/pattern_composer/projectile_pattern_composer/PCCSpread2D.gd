## Projectile Pattern Component
extends PatternComposerComponent
class_name PCCSpread2D
#@export_group("Spread Properties")


enum SpreadType {
	STRAIGHT,
	ANGLE
}

@export var spread_amount : int = 3
@export var spread_type : SpreadType = SpreadType.ANGLE
@export var spread_value : float = 5

func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	var _new_pattern_composer_pack : Array[PatternComposerData] = []
	match spread_type:
		SpreadType.STRAIGHT:
			for pattern_data : PatternComposerData in pattern_composer_pack:
				_new_pattern_composer_pack.append_array(_add_projectile_straight_spread(pattern_data))
		SpreadType.ANGLE:
			for pattern_data : PatternComposerData in pattern_composer_pack:
				_new_pattern_composer_pack.append_array(_add_projectile_angle_spread(pattern_data))
	return _new_pattern_composer_pack


func _add_projectile_straight_spread(pattern_data: PatternComposerData) -> Array[PatternComposerData]:
	var _new_instances : Array[PatternComposerData] = []

	var _half_total_width : float = (spread_amount - 1) * spread_value / 2.0
	var _projectile_position : Vector2 = pattern_data.position

	for i in range(spread_amount):
		var _new_pattern_data := PatternComposerData.new()
		_new_pattern_data.position = pattern_data.position
		_new_pattern_data.direction = pattern_data.direction
		_new_pattern_data.rotation = pattern_data.rotation
		_new_pattern_data.speed_mod = pattern_data.speed_mod
		
		var _offset : float = (i * spread_value) - _half_total_width
		var _point : Vector2 = _projectile_position + pattern_data.direction.rotated(deg_to_rad(90)) * _offset

		_new_pattern_data.position = _point

		_new_instances.append(_new_pattern_data)

	return _new_instances

func _add_projectile_angle_spread(pattern_data: PatternComposerData) -> Array[PatternComposerData]:
	var _new_instances : Array[PatternComposerData] = []

	var _half_total_deg : float = (spread_amount - 1) * spread_value / 2.0

	for i in range(spread_amount):
		var _offset : float = (i * spread_value) - _half_total_deg
		var _direction_vector : Vector2 = deg_to_dir(rad_to_deg(pattern_data.direction.angle()) - _offset)
		var _new_pattern_data := PatternComposerData.new()
		_new_pattern_data.position = pattern_data.position
		_new_pattern_data.direction = pattern_data.direction
		_new_pattern_data.rotation = pattern_data.rotation
		_new_pattern_data.speed_mod = pattern_data.speed_mod

		_new_pattern_data.direction = _direction_vector
	
		_new_instances.append(_new_pattern_data)


	return _new_instances

func deg_to_dir(deg: float) -> Vector2:
	var radian_angle := deg_to_rad(deg)
	var x := cos(radian_angle)
	var y := sin(radian_angle)
	return Vector2(x, y)
