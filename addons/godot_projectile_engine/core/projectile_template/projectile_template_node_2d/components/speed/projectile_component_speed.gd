extends ProjectileComponent
class_name ProjectileComponentSpeed

## Core component that manages projectile speed and speed behaviors.
##
## Handles base speed value and processes all attached speed behaviors
## (like acceleration, curves, clamping) each physics frame.

## Returns the component's identifier name
func get_component_name() -> StringName:
	return "projectile_component_speed"

## Base speed value (in units per second)
@export var speed: float = 100.0

## Array of speed behaviors to apply (acceleration, curves, etc)
@export var component_behaviors : Array[ProjectileBehaviorSpeed] = []

# Internal base speed cache
var base_speed : float = 100.0
# Temporary array for behavior processing
var _component_behavior_convert : Array[ProjectileBehavior]

var speed_mod : float

func _ready() -> void:
	# Cache initial speed value
	base_speed = speed


## Processes speed behaviors each physics frame
func _physics_process(delta: float) -> void:
	if !active:
		return

	# if !component_behaviors:
	# 	return

	# # Convert behaviors to base type for processing
	# _component_behavior_convert.assign(component_behaviors)

	# update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, owner.behavior_context)



## Processes all speed behaviors and applies their modifications
func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
		speed = _behavior.process_behavior(speed, _context)


func get_speed() -> float:
	return speed
