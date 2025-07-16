extends ProjectileComponent
class_name ProjectileComponentBouncing

## Component that handles projectile bouncing behavior using ProjectileBehaviorBouncing resources.
## Uses the existing Area2D collision system of Projectile2D for collision detection.

signal projectile_bounced(_collision_point: Vector2, _collision_normal: Vector2, bounce_count: int)
signal max_bounces_reached(bounce_count: int)

func get_component_name() -> StringName:
	return "projectile_component_bouncing"

## Maximum number of bounces before the projectile is destroyed (-1 = infinite)
@export var max_bounces: int = -1

## Array of bouncing behaviors that define how the projectile bounces
@export var component_behaviors: Array[ProjectileBehaviorBouncing] = []

var bounce_count: int = 0

var _component_behavior_convert: Array[ProjectileBehavior]
var _projectile_2d: Projectile2D
var _connected_to_signals: bool = false
var _collision_body: ProjectileBouncingHelper
var _collider: KinematicCollision2D
var _collision_point: Vector2
var _collision_normal: Vector2

func _ready() -> void:
	# Get the projectile Area2D (owner should be Projectile2D which extends Area2D)
	if owner and owner is Projectile2D:
		_projectile_2d = owner as Projectile2D

	if _projectile_2d:
		_connect_to_area_signals()

func _physics_process(delta: float) -> void:
	if !active and _projectile_2d:
		return

	if !_collision_body:
		ProjectileEngine.projectile_environment.request_bouncing_helper(_projectile_2d.get_node("CollisionShape2D").shape)
		ProjectileEngine.projectile_environment.projectile_bouncing_helper.transform = _projectile_2d.transform
		_collision_body = ProjectileEngine.projectile_environment.projectile_bouncing_helper
	
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
	if max_bounces >= 0 and bounce_count >= max_bounces:
		max_bounces_reached.emit(bounce_count)
		return
	_collision_body.transform = _projectile_2d.transform
	_collision_body.force_update_transform()
	_collision_body.collision_layer = _projectile_2d.collision_layer
	_collision_body.collision_mask = _projectile_2d.collision_mask
	_collision_body.global_position = _projectile_2d.global_position

	_collider = _collision_body.move_and_collide(Vector2.ZERO)

	if !_collider:
		return

	_collision_point = _collider.get_position()
	_collision_normal = _collider.get_normal()
	
	component_context["collision_point"] = _collision_point
	component_context["collision_normal"] = _collision_normal

	process_projectile_behavior(_component_behavior_convert, component_context)


func process_projectile_behavior(_behaviors: Array[ProjectileBehavior], _context: Dictionary) -> void:
	for _behavior in _behaviors:
		if !_behavior or !_behavior.active:
			continue
		_behavior = _behavior as ProjectileBehaviorBouncing
		var _bouncing_result: bool = _behavior.process_behavior(null, _context)
		if _bouncing_result:
			bounce_count += 1
			projectile_bounced.emit(_collision_point, _collision_normal, bounce_count)


## Gets the current bounce count
func get_bounce_count() -> int:
	return bounce_count

## Resets the bounce count
func reset_bounce_count() -> void:
	bounce_count = 0

func active_component() -> void:
	if _projectile_2d and !_connected_to_signals:
		_connect_to_area_signals()

func deactivate_component() -> void:
	if _connected_to_signals:
		_disconnect_from_area_signals()

func _exit_tree() -> void:
	_disconnect_from_area_signals()
