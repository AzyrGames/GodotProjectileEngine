extends ProjectileComponent
class_name ProjectileComponentDirection


func get_component_name() -> StringName:
	return "projectile_component_direction"

@export var direction: Vector2 = Vector2.RIGHT:
	get():
		return direction.snappedf(0.001)

@export var component_behaviors : Array[ProjectileBehaviorDirection] = []

var base_direction : Vector2 = Vector2.RIGHT

var direction_rotation : float = 0.0
var direction_addition : Vector2


var raw_direction : Vector2 = Vector2.RIGHT
var _component_behavior_convert : Array[ProjectileBehavior]

func _ready() -> void:
	base_direction = direction
	raw_direction = base_direction


## Processes speed behaviors each physics frame
func _physics_process(delta: float) -> void:
	if !active : return

	# if !component_behaviors: return

	# # Convert behaviors to base type for processing
	# _component_behavior_convert.assign(component_behaviors)

	# update_behavior_context(_component_behavior_convert)
	# print(owner.behavior_context)
	process_projectile_behavior(_component_behavior_convert, owner.behavior_context)
	pass

## Processes all direction behaviors and applies their modifications
func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	var _projectile_component_speed := get_component("projectile_component_speed")
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
		var _new_direction_array : Array = _behavior.process_behavior(direction, _context)
		if _new_direction_array[0] != direction:

			raw_direction = _new_direction_array[0]
			direction = raw_direction.normalized()

		if _new_direction_array.size() == 2:
			direction_rotation = _new_direction_array[1]

		if _new_direction_array.size() == 3:
			direction_addition = _new_direction_array[2]


func get_direction() -> Vector2:
	var _final_direction := direction
	if direction_rotation != 0.0:
		_final_direction = _final_direction.rotated(direction_rotation)
	return _final_direction
	pass


func get_raw_direction() -> Vector2:
	var _final_raw_direction := raw_direction
	if direction_addition != Vector2.ZERO:
		_final_raw_direction = _final_raw_direction + direction_addition
	if direction_rotation != 0.0:
		_final_raw_direction = _final_raw_direction.rotated(direction_rotation)
	return _final_raw_direction
	pass
