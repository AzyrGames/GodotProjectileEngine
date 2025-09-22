## Projectile Pattern Component
@icon("uid://bgwne7sou0e8r")
extends PatternComposerComponent
class_name PCCSpread2D


enum SpreadType {
	STRAIGHT,
	ANGLE,
	HYBRID
}


@export var spread_type: SpreadType = SpreadType.ANGLE
@export var spread_amount: int = 3
# @export var spread_value : float = 5
@export var spread_distance: float = 10
@export var spread_angle: float = 5


@export_group("Random")
@export var spread_amount_random: Vector3i
@export var spread_distance_random: Vector3
@export var spread_angle_random: Vector3


func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData],
	_pattern_composer_context: PatternComposerContext
	) -> Array:
	if spread_amount_random != Vector3i.ZERO:
		spread_amount = ProjectileEngine.get_random_int_value(spread_amount_random)
	if spread_distance_random != Vector3.ZERO:
		spread_distance = ProjectileEngine.get_random_float_value(spread_distance_random)
	if spread_angle_random != Vector3.ZERO:
		spread_angle = ProjectileEngine.get_random_float_value(spread_angle_random)

	_new_pattern_composer_pack = []
	match spread_type:
		SpreadType.STRAIGHT:
			for _pattern_composer_data: PatternComposerData in _pattern_composer_pack:
				_new_pattern_composer_pack.append_array(_add_projectile_straight_spread(_pattern_composer_data))
		SpreadType.ANGLE:
			for _pattern_composer_data: PatternComposerData in _pattern_composer_pack:
				_new_pattern_composer_pack.append_array(_add_projectile_angle_spread(_pattern_composer_data))
		SpreadType.HYBRID:
			for _pattern_composer_data: PatternComposerData in _pattern_composer_pack:
				_new_pattern_composer_pack.append_array(_add_projectile_hybrid_spread(_pattern_composer_data))
	return _new_pattern_composer_pack

var _new_sub_pattern_composer_data: Array[PatternComposerData]
var _half_total_width: float
var _half_total_deg: float
var _projectile_position: Vector2
var _offset_angle: float
var _offset_distance: float
var _point_position: Vector2
var _point_direction: Vector2

func _add_projectile_straight_spread(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data = []
	_half_total_width = (spread_amount - 1) * spread_distance / 2.0
	for i in range(spread_amount):
		_new_pattern_composer_data = _pattern_composer_data.duplicate()
		_offset_distance = (i * spread_distance) - _half_total_width
		_new_pattern_composer_data.position += (_new_pattern_composer_data.direction * _offset_distance)
		_new_sub_pattern_composer_data.append(_new_pattern_composer_data)
	return _new_sub_pattern_composer_data

func _add_projectile_angle_spread(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data = []
	_half_total_deg = (spread_amount - 1) * spread_angle / 2.0
	for i in range(spread_amount):
		_new_pattern_composer_data = _pattern_composer_data.duplicate()
		_offset_angle = (i * spread_angle) - _half_total_deg
		_new_pattern_composer_data.direction = _pattern_composer_data.direction.rotated(deg_to_rad(_offset_angle)).normalized()
		_new_sub_pattern_composer_data.append(_new_pattern_composer_data)
	return _new_sub_pattern_composer_data

func _add_projectile_hybrid_spread(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_sub_pattern_composer_data = []
	_half_total_width = (spread_amount - 1) * spread_distance / 2.0
	_half_total_deg = (spread_amount - 1) * spread_angle / 2.0
	for i in range(spread_amount):
		_new_pattern_composer_data = _pattern_composer_data.duplicate()
		_offset_distance = (i * spread_distance) - _half_total_width
		_offset_angle = (i * spread_angle) - _half_total_deg
		_new_pattern_composer_data.direction = _pattern_composer_data.direction.rotated(deg_to_rad(_offset_angle)).normalized()
		_new_pattern_composer_data.position += (_new_pattern_composer_data.direction * _offset_distance)
		_new_sub_pattern_composer_data.append(_new_pattern_composer_data)
	return _new_sub_pattern_composer_data


#func _deg_to_dir(deg: float) -> Vector2:
#	var radian_angle := deg_to_rad(deg)
#	var x := cos(radian_angle)
#	var y := sin(radian_angle)
#	return Vector2(x, y)
