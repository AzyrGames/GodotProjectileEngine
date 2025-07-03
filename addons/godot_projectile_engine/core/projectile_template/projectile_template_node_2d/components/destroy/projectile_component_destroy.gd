extends ProjectileComponent
class_name ProjectileComponentDestroy

## Projectile destroy component that manages different destroy behaviors

## Array of destroy behaviors to process
@export var component_behaviors: Array[ProjectileBehaviorDestroy] = []

## Whether to destroy immediately when any behavior triggers
@export var destroy_on_first_trigger: bool = true

## Whether to emit signals when projectile is destroyed
@export var emit_destroy_signals: bool = true

## Signal emitted when projectile is about to be destroyed
signal projectile_destroying(projectile: Node, triggered_behaviors: Array[ProjectileBehaviorDestroy])

## Signal emitted after projectile is destroyed
signal projectile_destroyed(projectile: Node, triggered_behaviors: Array[ProjectileBehaviorDestroy])

var _component_behavior_convert: Array[ProjectileBehavior]
var _triggered_behaviors: Array[ProjectileBehaviorDestroy] = []

func get_component_name() -> StringName:
	return "projectile_component_destroy"

func _ready() -> void:
	pass

## Processes destroy behaviors each physics frame
func _physics_process(delta: float) -> void:
	if !active:
		return

	# if !component_behaviors:
	# 	return

	# # Convert behaviors to base type for processing
	# _component_behavior_convert.assign(component_behaviors)

	# update_behavior_context(_component_behavior_convert)
	process_projectile_behavior(_component_behavior_convert, owner.behavior_context)

## Processes all destroy behaviors and handles destruction
func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	if !owner:
		return
	
	# Add projectile owner to context for behaviors to access scene tree
	_context["projectile_owner"] = owner
	
	_triggered_behaviors.clear()
	
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
		
		var destroy_behavior = _behavior as ProjectileBehaviorDestroy
		if !destroy_behavior:
			continue
		
		var should_destroy: bool = destroy_behavior.process_behavior(null, _context)
		
		if should_destroy:
			_triggered_behaviors.append(destroy_behavior)
			
			if destroy_on_first_trigger:
				break
	
	# Handle destruction if any behaviors triggered
	if _triggered_behaviors.size() > 0:
		_handle_destruction()

## Handles the actual destruction process
func _handle_destruction() -> void:
	if !owner:
		return
	
	# Emit pre-destruction signal
	if emit_destroy_signals:
		projectile_destroying.emit(owner, _triggered_behaviors)
	
	# Call on_destroy for all triggered behaviors
	for behavior in _triggered_behaviors:
		if behavior.emit_destroy_signal:
			behavior.projectile_destroyed.emit(owner, behavior)
		behavior.on_destroy(owner, component_context)
	
	# Emit post-destruction signal
	if emit_destroy_signals:
		projectile_destroyed.emit(owner, _triggered_behaviors)
	
	# Destroy the projectile
	if is_instance_valid(owner):
		owner.queue_free()

## Manually trigger destruction with specific behaviors
func trigger_destruction(behaviors: Array[ProjectileBehaviorDestroy] = []) -> void:
	if behaviors.is_empty():
		_triggered_behaviors = component_behaviors.duplicate()
	else:
		_triggered_behaviors = behaviors.duplicate()
	
	_handle_destruction()

## Add a destroy behavior at runtime
func add_destroy_behavior(behavior: ProjectileBehaviorDestroy) -> void:
	if behavior and not component_behaviors.has(behavior):
		component_behaviors.append(behavior)

## Remove a destroy behavior at runtime
func remove_destroy_behavior(behavior: ProjectileBehaviorDestroy) -> void:
	var index = component_behaviors.find(behavior)
	if index >= 0:
		component_behaviors.remove_at(index)

## Check if any destroy behavior would trigger without actually destroying
func check_would_destroy() -> bool:
	if !component_behaviors:
		return false
	
	_component_behavior_convert.assign(component_behaviors)
	update_behavior_context(_component_behavior_convert)
	
	var context = component_context.duplicate()
	context["projectile_owner"] = owner
	
	for _behavior in _component_behavior_convert:
		if !_behavior or !_behavior.active:
			continue
		
		var destroy_behavior = _behavior as ProjectileBehaviorDestroy
		if !destroy_behavior:
			continue
		
		if destroy_behavior.process_behavior(null, context):
			return true
	
	return false

## Get all behaviors that would currently trigger
func get_triggering_behaviors() -> Array[ProjectileBehaviorDestroy]:
	var triggering: Array[ProjectileBehaviorDestroy] = []
	
	if !component_behaviors:
		return triggering
	
	_component_behavior_convert.assign(component_behaviors)
	update_behavior_context(_component_behavior_convert)
	
	var context = component_context.duplicate()
	context["projectile_owner"] = owner
	
	for _behavior in _component_behavior_convert:
		if !_behavior or !_behavior.active:
			continue
		
		var destroy_behavior = _behavior as ProjectileBehaviorDestroy
		if !destroy_behavior:
			continue
		
		if destroy_behavior.process_behavior(null, context):
			triggering.append(destroy_behavior)
	
	return triggering
