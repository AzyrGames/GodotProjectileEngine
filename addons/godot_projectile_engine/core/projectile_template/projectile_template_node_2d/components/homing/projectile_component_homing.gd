extends ProjectileComponent
class_name ProjectileComponentHoming


func get_component_name() -> StringName:
	return "projectile_component_homing"


@export var component_behaviors : Array[ProjectileBehaviorHoming] = []

var _component_behavior_convert : Array[ProjectileBehavior]


func _ready() -> void:
	pass


## Processes homing behaviors each physics frame
func _physics_process(delta: float) -> void:
	if !active:
		return

	# if !component_behaviors:
	# 	return

	# # Convert behaviors to base type for processing
	# _component_behavior_convert.assign(component_behaviors)

	# update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, owner.behavior_context)



## Processes all homing behaviors and applies their modifications to direction
func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	var _projectile_component_direction := get_component("projectile_component_direction")
	if !_projectile_component_direction:
		return
	
	# Add projectile owner to context for behaviors to access scene tree
	_context["projectile_owner"] = owner
		
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
			
		var _homing_result: Array = _behavior.process_behavior(_projectile_component_direction.get_direction(), _context)
		
		if _homing_result.size() > 0 and _homing_result[0] != _projectile_component_direction.get_direction():
			# Apply the new direction from homing behavior
			_projectile_component_direction.raw_direction = _homing_result[0]
			_projectile_component_direction.direction = _projectile_component_direction.raw_direction.normalized()
			
		# Handle additional rotation if provided
		if _homing_result.size() >= 2:
			_projectile_component_direction.direction_rotation = _homing_result[1]
			
		# Handle additional direction offset if provided
		if _homing_result.size() >= 3:
			_projectile_component_direction.direction_addition = _homing_result[2]
