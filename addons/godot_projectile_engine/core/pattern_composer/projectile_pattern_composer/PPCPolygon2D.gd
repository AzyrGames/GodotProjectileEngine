## Bullet Pattern Component Base

extends ProjectilePatternComponent
class_name PPCPolygon2D

@export var radius : float = 5.0
@export var polygon_sides : int = 5
@export var spread_out : bool = false


#@export_group("Polygon Randomizer")


func process_pattern(pattern_packs: Array, _composer_var : Dictionary) -> Array:
	var _new_bullet_packs := []
	for instance : Dictionary in pattern_packs:

		_new_bullet_packs.append_array(_add_bullet_polygon(instance))

	return _new_bullet_packs


func _add_bullet_polygon(instance: Dictionary) -> Array:
	var _new_polygon_instances : Array = []
	for i in range(polygon_sides):
		var _new_instance := instance.duplicate()
		
		var _theta : float = PI * 2 / polygon_sides * i
		# var _point := instance.position + radius * Vector2.from_angle(_theta) as Vector2
		var _point := instance.position + radius * Vector2.from_angle(_theta + instance.direction.angle()) as Vector2

		if spread_out:
			var _direction := Vector2.from_angle(_theta)
			_direction = _direction.rotated(instance.direction.angle())
			_new_instance.direction = _direction

		_new_instance.position = _point
		
		_new_polygon_instances.append(_new_instance)
	
	return _new_polygon_instances
