extends ProjectileBehaviorDestroy
class_name ProjectileDestroyBoundary

## Boundary-based destroy behavior that destroys projectiles when they leave ProjectileBoundary2D.
## This node requite ProjetileBoundary2D

## Whether to destroy when entering boundary (true) or leaving boundary (false)
@export var destroy_on_enter: bool = false

var _init_boundary_2d : bool = false

var _space_state : PhysicsDirectSpaceState2D
var _point_query : PhysicsPointQueryParameters2D
var _projectile_boundary_2d : ProjectileBoundary2D

func _init() -> void:
	_point_query = PhysicsPointQueryParameters2D.new()

## Processes boundary-based destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	_projectile_boundary_2d = ProjectileEngine.projectile_boundary_2d
	if!_projectile_boundary_2d:
		return false
	if !_init_boundary_2d:
		_projectile_boundary_2d = ProjectileEngine.projectile_boundary_2d
		_space_state = _projectile_boundary_2d.get_world_2d().direct_space_state
		_point_query.collide_with_areas = true
		_point_query.collide_with_bodies = false
		_point_query.collision_mask = _projectile_boundary_2d.collision_mask

		_init_boundary_2d = true

	var projectile_owner = _context.get("projectile_owner")

	if not projectile_owner:
		return false

	return _check_projectile_boundary_2d(projectile_owner.global_position)

## Checks boundary using Area2D
func _check_projectile_boundary_2d(position: Vector2) -> bool:
	_point_query.position = position
	
	var result = _space_state.intersect_point(_point_query)
	var is_inside = false
	
	for collision in result:
		if collision.collider == _projectile_boundary_2d:
			is_inside = true
			break
	
	if destroy_on_enter:
		return is_inside
	else:
		return not is_inside

## Called when the projectile is destroyed
func on_destroy(_projectile: Node, _context: Dictionary) -> void:
	# Add any boundary-based destruction effects here
	pass
