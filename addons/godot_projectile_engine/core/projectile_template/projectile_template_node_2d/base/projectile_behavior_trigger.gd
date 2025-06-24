extends ProjectileBehavior
class_name ProjectileBehaviorTrigger

## Base class for trigger behaviors that can activate based on various conditions

@export var trigger_name : String = ""
@export var one_shot : bool = true
@export var destroy_on_trigger : bool = false

var _should_trigger : bool

func process_behavior(_value, _context: Dictionary) -> bool:
	return false
