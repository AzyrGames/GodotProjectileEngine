extends ProjectileBehavior
class_name ProjectileBehaviorTrigger

## Base class for trigger behaviors that can activate based on various conditions

@export var trigger_name : String = ""
@export var one_shot : bool = true
@export var destroy_on_trigger : bool = false

var has_triggered : bool = false

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [ProjectileEngine.BehaviorContext.LIFE_TIME_SECOND, ProjectileEngine.BehaviorContext.LIFE_DISTANCE]

func process_behavior(_value, _context: Dictionary) -> bool:
	if not active or has_triggered:
		return false
	
	var should_trigger = check_trigger_condition(_context)
	
	if should_trigger:
		_trigger_activated(_context)
		if one_shot:
			has_triggered = true
		return true
	
	return false

## Override this method in derived classes to implement specific trigger conditions
func check_trigger_condition(_context: Dictionary) -> bool:
	return false

func _trigger_activated(_context: Dictionary) -> void:
	if trigger_name.is_empty():
		return
	
	# Emit the trigger signal through the ProjectileEngine
	# Note: We'll need to pass the projectile instance somehow
	# This will be handled by the component that processes this behavior
	pass

func reset_trigger() -> void:
	has_triggered = false
