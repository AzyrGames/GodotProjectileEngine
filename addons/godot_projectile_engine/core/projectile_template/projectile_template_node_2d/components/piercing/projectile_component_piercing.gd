extends ProjectileComponent
class_name ProjectileComponentPiercing

## Component that handles projectile piercing behavior using ProjectileBehaviorPiercing resources.
## Uses the existing Area2D collision system of Projectile2D for collision detection.

signal target_pierced(_target: Node, piercing_count: int)
signal max_piercing_reached(piercing_count: int)

func get_component_name() -> StringName:
	return "projectile_component_piercing"

## Maximum number of targets that can be pierced (-1 = infinite)
@export var max_piercing_count: int = 3

## Array of piercing behaviors that define how the projectile pierces
@export var component_behaviors: Array[ProjectileBehaviorPiercing] = []

## Whether to stop the projectile when max piercing is reached
@export var stop_on_max_piercing: bool = false

## Whether to trigger destroy component when max piercing is reached
@export var trigger_destroy_on_max_piercing: bool = false

var piercing_count: int = 0
var pierced_targets: Array[Node] = []

var _component_behavior_convert: Array[ProjectileBehavior]
var _projectile_2d: Projectile2D
var _connected_to_signals: bool = false

func _ready() -> void:
	# Get the projectile Area2D (owner should be Projectile2D which extends Area2D)
	if owner and owner is Projectile2D:
		_projectile_2d = owner as Projectile2D

	if _projectile_2d:
		_connect_to_area_signals()

func _physics_process(delta: float) -> void:
	if !active or !_projectile_2d:
		return
	if !component_behaviors:
		return
	

	_component_behavior_convert.assign(component_behaviors)
	update_behavior_context(_component_behavior_convert)

## Connects to the Area2D signals for collision detection
func _connect_to_area_signals() -> void:
	if !_projectile_2d or _connected_to_signals:
		return
	
	if not _projectile_2d.body_entered.is_connected(_on_body_entered):
		_projectile_2d.body_entered.connect(_on_body_entered)
	
	if not _projectile_2d.area_entered.is_connected(_on_area_entered):
		_projectile_2d.area_entered.connect(_on_area_entered)
	
	_connected_to_signals = true

## Disconnects from Area2D signals
func _disconnect_from_area_signals() -> void:
	if !_projectile_2d or !_connected_to_signals:
		return
	
	if _projectile_2d.body_entered.is_connected(_on_body_entered):
		_projectile_2d.body_entered.disconnect(_on_body_entered)
	
	if _projectile_2d.area_entered.is_connected(_on_area_entered):
		_projectile_2d.area_entered.disconnect(_on_area_entered)
	
	_connected_to_signals = false

## Handles collision with a physics body
func _on_body_entered(body: Node2D) -> void:
	if !active: return
	_handle_collision(body)

## Handles collision with an area
func _on_area_entered(area: Area2D) -> void:
	if !active: return
	_handle_collision(area)

## Handles collision with any target
func _handle_collision(target: Node) -> void:
	# Skip if we've already pierced this target
	if pierced_targets.has(target):
		return
	
	# Check if we've reached max piercing count
	if max_piercing_count >= 0 and piercing_count >= max_piercing_count:
		max_piercing_reached.emit(piercing_count)
		_handle_max_piercing_reached()
		return
	
	# Add target to context for behaviors
	component_context["target"] = target
	component_context["piercing_count"] = piercing_count
	component_context["pierced_targets"] = pierced_targets
	
	# Process piercing behaviors
	var should_pierce = true
	for behavior in component_behaviors:
		if !behavior or !behavior.active:
			continue
		
		var pierce_result = behavior.process_behavior(null, component_context)
		if not pierce_result:
			should_pierce = false
			break
	
	if should_pierce:
		_pierce_target(target)

## Pierces a target and updates tracking
func _pierce_target(target: Node) -> void:
	pierced_targets.append(target)
	piercing_count += 1
	
	# Call on_pierce for all behaviors
	for behavior in component_behaviors:
		if behavior and behavior.active:
			behavior.on_pierce(_projectile_2d, target, component_context)
			if behavior.emit_piercing_signal:
				behavior.target_pierced.emit(_projectile_2d, target, piercing_count)
	
	target_pierced.emit(target, piercing_count)

## Handles when max piercing count is reached
func _handle_max_piercing_reached() -> void:
	# Call on_max_piercing_reached for all behaviors
	for behavior in component_behaviors:
		if behavior and behavior.active:
			behavior.on_max_piercing_reached(_projectile_2d, component_context)
			if behavior.emit_piercing_signal:
				behavior.max_piercing_reached.emit(_projectile_2d, piercing_count)
	
	if stop_on_max_piercing:
		# Stop the projectile by setting speed to 0
		var speed_component = get_component("projectile_component_speed")
		if speed_component:
			speed_component.speed = 0.0
	
	if trigger_destroy_on_max_piercing:
		# Trigger destroy component instead of directly destroying
		var destroy_component = get_component("projectile_component_destroy")
		if destroy_component and destroy_component.has_method("trigger_destruction"):
			destroy_component.trigger_destruction()

## Gets the current piercing count
func get_piercing_count() -> int:
	return piercing_count

## Gets the list of pierced targets
func get_pierced_targets() -> Array[Node]:
	return pierced_targets.duplicate()

## Checks if a target has been pierced
func has_pierced_target(target: Node) -> bool:
	return pierced_targets.has(target)

## Resets the piercing state
func reset() -> void:
	piercing_count = 0
	pierced_targets.clear()

## Manually add a target to the pierced list (useful for special cases)
func add_pierced_target(target: Node) -> void:
	if not pierced_targets.has(target):
		pierced_targets.append(target)

## Remove a target from the pierced list (useful for special cases)
func remove_pierced_target(target: Node) -> void:
	var index = pierced_targets.find(target)
	if index >= 0:
		pierced_targets.remove_at(index)

func active_component() -> void:
	if _projectile_2d and !_connected_to_signals:
		_connect_to_area_signals()

func deactivate_component() -> void:
	if _connected_to_signals:
		_disconnect_from_area_signals()

func _exit_tree() -> void:
	_disconnect_from_area_signals()
