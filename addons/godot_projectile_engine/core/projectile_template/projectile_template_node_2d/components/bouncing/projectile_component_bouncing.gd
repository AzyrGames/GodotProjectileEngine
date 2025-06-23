extends ProjectileComponent
class_name ProjectileComponentBouncing

## Component that handles projectile bouncing behavior using ProjectileBehaviorBouncing resources.
## Uses the existing Area2D collision system of Projectile2D for collision detection.

## Emitted when the projectile bounces off a surface
signal projectile_bounced(collision_point: Vector2, collision_normal: Vector2, bounce_count: int)

## Emitted when the projectile reaches maximum bounces and should be destroyed
signal max_bounces_reached(bounce_count: int)

func get_component_name() -> StringName:
	return "projectile_component_bouncing"

## Maximum number of bounces before the projectile is destroyed (-1 = infinite)
@export var max_bounces: int = -1

## Array of bouncing behaviors that define how the projectile bounces
@export var component_behaviors: Array[ProjectileBehaviorBouncing] = []

var bounce_count: int = 0

# Internal variables
var _component_behavior_convert: Array[ProjectileBehavior]
var _projectile_2d: Projectile2D
var _connected_to_signals: bool = false

func _ready() -> void:
	# Get the projectile Area2D (owner should be Projectile2D which extends Area2D)
	if !owner or owner is not Projectile2D: return
	
	_projectile_2d = owner as Projectile2D

	if _projectile_2d:
		_connect_to_area_signals()

func _physics_process(delta: float) -> void:
	if !active and _projectile_2d:
		return

	if !ProjectileEngine.projectile_environment.projectile_bouncing_helper:
		ProjectileEngine.projectile_environment.request_bouncing_helper(_projectile_2d.get_node("CollisionShape2D").duplicate())
	
	if !component_behaviors:
		return
	
	# Convert behaviors to base type for processing
	_component_behavior_convert.assign(component_behaviors)
	update_behavior_context(_component_behavior_convert)
	

	# Process bouncing behaviors (mainly for continuous effects)
	# process_projectile_behavior(_component_behavior_convert, component_context)

## Connects to the Area2D signals for collision detection
func _connect_to_area_signals() -> void:
	if !_projectile_2d or _connected_to_signals:
		return
	
	if not _projectile_2d.body_entered.is_connected(_on_body_entered):
		_projectile_2d.body_entered.connect(_on_body_entered)
	
	_connected_to_signals = true

## Disconnects from Area2D signals
func _disconnect_from_area_signals() -> void:
	if !_projectile_2d or !_connected_to_signals:
		return
	
	if _projectile_2d.body_entered.is_connected(_on_body_entered):
		_projectile_2d.body_entered.disconnect(_on_body_entered)
	
	
	_connected_to_signals = false

## Handles collision with a physics body
func _on_body_entered(body: Node2D) -> void:
	if !active: return
	# Create temporary CharacterBody2D to detect collision
	var collision_body := ProjectileEngine.projectile_environment.projectile_bouncing_helper
	var collision_point := _projectile_2d.global_position
	var collision_normal := Vector2.UP
	# collision_body.get_collision_shape
	collision_body.collision_layer = _projectile_2d.collision_layer
	collision_body.collision_mask = _projectile_2d.collision_mask

	collision_body.global_position = _projectile_2d.global_position

	var collision:= collision_body.move_and_collide(Vector2.ZERO)
	collision_point = collision.get_position()
	collision_normal = collision.get_normal()
	
	_handle_bounce(collision_point, collision_normal, body)


## Handles the actual bouncing logic
func _handle_bounce(collision_point: Vector2, collision_normal: Vector2, collider: Node = null) -> void:
	if max_bounces >= 0 and bounce_count >= max_bounces:
		max_bounces_reached.emit(bounce_count)
		return
	
	var direction_component = get_component("projectile_component_direction")
	var current_direction = direction_component.get_direction()
	var new_direction = current_direction.reflect(collision_normal)

	direction_component.direction = new_direction * -1.0
	
	process_projectile_behavior(_component_behavior_convert, component_context)

	bounce_count += 1
	
	# Emit bounce signal
	projectile_bounced.emit(collision_point, collision_normal, bounce_count)


## Processes bouncing behaviors
func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	# Most bouncing logic happens in _handle_bounce
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue

		
		pass



## Gets the current bounce count
func get_bounce_count() -> int:
	return bounce_count

## Resets the bounce count
func reset_bounce_count() -> void:
	bounce_count = 0

## Manually trigger a bounce (useful for custom collision detection)
func trigger_bounce(collision_point: Vector2, collision_normal: Vector2, collider: Node = null) -> void:
	_handle_bounce(collision_point, collision_normal, collider)

func active_component() -> void:
	if _projectile_2d and !_connected_to_signals:
		_connect_to_area_signals()

func deactive_compoment() -> void:
	if _connected_to_signals:
		_disconnect_from_area_signals()

func _exit_tree() -> void:
	_disconnect_from_area_signals()



## Energy retention factor on each bounce (0.0 = no energy, 1.0 = perfect bounce)
# @export_range(0.0, 1.0) var bounce_energy_retention: float = 0.8

# ## Minimum speed threshold below which the projectile stops bouncing
# @export var min_bounce_speed: float = 10.0

# ## Enable automatic destruction when speed falls below threshold
# @export var destroy_on_low_speed: bool = true

## Enable bouncing on body entered signals
# @export var bounce_on_body_entered: bool = true



	# var speed_component = get_component("projectile_component_speed")
	
	# if !direction_component or !speed_component:
	# 	return
	
	# var current_direction = direction_component.get_direction()
	# var current_speed = speed_component.get_speed()
	
	# # Create context for behavior processing
	# var bounce_context = component_context.duplicate()
	# bounce_context["collision_point"] = collision_point
	# bounce_context["collision_normal"] = collision_normal
	# bounce_context["bounce_count"] = bounce_count
	# bounce_context["collision_velocity"] = current_speed
	# bounce_context["collider"] = collider
	# bounce_context["speed"] = current_speed
	
	# # Process behaviors to get new direction and speed
	# var new_direction = current_direction
	# var new_speed = current_speed

	# if component_behaviors.size() > 0:
	# 	# Use behaviors to calculate bounce
	# 	for behavior in component_behaviors:
	# 		if !behavior or !behavior.active:
	# 			continue
			
	# 		var result = behavior.process_behavior(current_direction, bounce_context)
	# 		if result is Array and result.size() >= 2:
	# 			new_direction = result[0] as Vector2
	# 			new_speed = result[1] as float
	# 			break  # Use first active behavior
	# else:
	# 	# Default bounce behavior if no behaviors are defined4
	# 	new_direction = current_direction.reflect(collision_normal)
	# 	new_speed = current_speed * bounce_energy_retention
	
	# # Update direction and speed
	# direction_component.direction = new_direction * -1.0

	# if speed_component.has_method("set_speed"):
	# 	speed_component.set_speed(new_speed)
	# else:
	# 	speed_component.speed = new_speed

	# Increment bounce count