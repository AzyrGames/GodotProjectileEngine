extends ProjectileBehaviorDestroy
class_name ProjectileDestroyCollision

## Collision-based destroy behavior that destroys projectiles when collide with object

## Destroy when projectile collide with an area
@export var destroy_on_area_collide: bool = true

## Destroy when projectile collide with a body
@export var destroy_on_body_collide: bool = true

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
	return [
		ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER
	]

## Processes collision-based destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	if !destroy_on_area_collide or !destroy_on_body_collide:
		return false
	if not _context.has(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER):
		return false
	var behavior_owner = _context.get(ProjectileEngine.BehaviorContext.BEHAVIOR_OWNER)
	
	if not behavior_owner:
		return false
	if behavior_owner is Projectile2D:
		if destroy_on_area_collide:
			if behavior_owner.has_overlapping_areas():
				return true
		if destroy_on_body_collide:
			if behavior_owner.has_overlapping_bodies():
				return true
	
	return false