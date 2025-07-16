## Projectile Pattern Component Base

extends PatternComposerComponent
class_name PCCPolygon2D

@export var radius : float = 5.0
@export var polygon_sides : int = 5
@export var spread_out : bool = true


#@export_group("Polygon Randomizer")


func process_pattern(pattern_composer_pack: Array[PatternComposerData], _pattern_composer_context : PatternComposerContext) -> Array:
	var _new_projectile_packs : Array[PatternComposerData] = []
	for pattern_data : PatternComposerData in pattern_composer_pack:

		_new_projectile_packs.append_array(_add_projectile_polygon(pattern_data))

	return _new_projectile_packs


func _add_projectile_polygon(pattern_data: PatternComposerData) -> Array[PatternComposerData]:
	var _new_polygon_instances : Array[PatternComposerData] = []
	for i in range(polygon_sides):
		var _new_pattern_data := PatternComposerData.new()
		_new_pattern_data.position = pattern_data.position
		_new_pattern_data.direction = pattern_data.direction
		_new_pattern_data.rotation = pattern_data.rotation
		_new_pattern_data.speed_mod = pattern_data.speed_mod
		
		var _theta : float = PI * 2 / polygon_sides * i
		# var _point := pattern_data.position + radius * Vector2.from_angle(_theta) as Vector2
		var _point := pattern_data.position + radius * Vector2.from_angle(_theta + pattern_data.direction.angle()) as Vector2

		if spread_out:
			var _direction := Vector2.from_angle(_theta)
			_direction = _direction.rotated(pattern_data.direction.angle())
			_new_pattern_data.rotation = _direction.angle()
			_new_pattern_data.direction = _direction

		_new_pattern_data.position = _point
		
		_new_polygon_instances.append(_new_pattern_data)
	
	return _new_polygon_instances
