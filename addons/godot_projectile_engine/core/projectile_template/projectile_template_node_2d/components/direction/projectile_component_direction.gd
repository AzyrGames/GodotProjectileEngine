extends ProjectileComponent
class_name ProjectileComponentDirection


func get_component_name() -> StringName:
	return "projectile_component_direction"

@export var direction: Vector2 = Vector2.RIGHT

@export var component_behaviors : Array[ProjectileBehaviorDirection] = []

var base_direction : Vector2 = Vector2.RIGHT

var raw_direction : Vector2 = Vector2.RIGHT
var _component_behavior_convert : Array[ProjectileBehavior]

func _ready() -> void:
	base_direction = direction
	raw_direction = base_direction


## Processes speed behaviors each physics frame
func _physics_process(delta: float) -> void:
	if !active : return

	if !component_behaviors: return

	# Convert behaviors to base type for processing
	_component_behavior_convert.assign(component_behaviors)

	update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, component_context)
	pass

## Processes all direction behaviors and applies their modifications
func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	var _projectile_component_speed := get_component("projectile_component_speed")
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
		var _new_direction : Vector2 = _behavior.process_behavior(direction, _context)
		if _new_direction != direction:
			raw_direction = _new_direction
			direction = raw_direction.normalized()
