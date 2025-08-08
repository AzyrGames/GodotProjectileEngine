## Projectile Pattern Component Base
@icon("uid://dnwhtomxmwqr7")
extends PatternComposerComponent
class_name PCCPolygon2D

@export var radius: float = 5.0
@export var polygon_sides: int = 5
@export var spread_out: bool = true

@export_group("Random")
@export var radius_random: Vector3
@export var polygon_sides_random: Vector3i

var _theta: float
var _point_position: Vector2
var _point_direction: Vector2
var _point_direction_rotation: float
var _new_polygon_composer_data: Array[PatternComposerData] = []


func process_pattern(
	_pattern_composer_pack: Array[PatternComposerData],
	_pattern_composer_context: PatternComposerContext
	) -> Array:
	if radius_random != Vector3.ZERO:
		radius = ProjectileEngine.get_random_float_value(radius_random)
	if polygon_sides_random != Vector3i.ZERO:
		polygon_sides = ProjectileEngine.get_random_int_value(polygon_sides_random)

	_new_pattern_composer_pack.clear()
	for _pattern_composer_data: PatternComposerData in _pattern_composer_pack:
		_new_pattern_composer_pack.append_array(_add_projectile_polygon(_pattern_composer_data))

	return _new_pattern_composer_pack


func _add_projectile_polygon(_pattern_composer_data: PatternComposerData) -> Array[PatternComposerData]:
	_new_polygon_composer_data.clear()
	for i in range(polygon_sides):
		_new_pattern_composer_data = _pattern_composer_data.duplicate()
		_theta = PI * 2 / polygon_sides * i
		_point_position = _pattern_composer_data.position + \
			radius * Vector2.from_angle(
				_theta + _pattern_composer_data.direction.angle() + \
				_pattern_composer_data.direction_rotation)
		_new_pattern_composer_data.position = _point_position
		
		if spread_out:
			_new_pattern_composer_data.direction_rotation += _theta

		_new_polygon_composer_data.append(_new_pattern_composer_data)
	return _new_polygon_composer_data
