extends ProjectileComponent
class_name ProjectileComponentTrigger

## Core component that manages projectile triggers and trigger behaviors.
##
## Handles trigger conditions and processes all attached trigger behaviors
## (like time-based, distance-based, speed-based triggers) each physics frame.

## Returns the component's identifier name
func get_component_name() -> StringName:
	return "projectile_component_trigger"

## Array of trigger behaviors to apply (time, distance, speed triggers, etc)
@export var component_behaviors : Array[ProjectileBehaviorTrigger] = []

# Temporary array for behavior processing
var _component_behavior_convert : Array[ProjectileBehavior]


## Processes trigger behaviors each physics frame
func _physics_process(delta: float) -> void:
	if !active:
		return

	if !component_behaviors:
		return

	# Convert behaviors to base type for processing
	_component_behavior_convert.assign(component_behaviors)

	update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, component_context)


## Processes all trigger behaviors and checks for trigger activations
func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
		
		if _behavior is ProjectileBehaviorTrigger:
			var trigger_behavior = _behavior as ProjectileBehaviorTrigger
			var triggered = trigger_behavior.process_behavior(null, _context)
			
			if triggered:
				_handle_trigger_activated(trigger_behavior, _context)


func _handle_trigger_activated(trigger_behavior: ProjectileBehaviorTrigger, _context: Dictionary) -> void:
	if trigger_behavior.trigger_name.is_empty():
		return
	
	# Emit the new projectile trigger signal for ProjectileTemplateNode2D
	ProjectileEngine.projectile_node_triggered.emit(trigger_behavior.trigger_name, owner)
	
	# Handle destroy_on_trigger
	if trigger_behavior.destroy_on_trigger:
		# Signal that this projectile should be destroyed
		# This would be handled by the projectile system
		var destroy_component = get_component("projectile_component_destroy")
		if destroy_component and destroy_component.has_method("trigger_destruction"):
			destroy_component.trigger_destruction()