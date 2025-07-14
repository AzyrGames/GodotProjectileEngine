extends ProjectileBehavior
class_name ProjectileBehaviorTrigger

## Base class for trigger behaviors that can activate based on various conditions

@export var trigger_name : String = ""
@export var trigger_repeat_count : int = 1
@export var destroy_when_done : bool = false

var _should_trigger : bool = false

var _trigger_behavior_values : Dictionary = {}

func process_behavior(_value, _context: Dictionary) -> Dictionary:
	return {}
