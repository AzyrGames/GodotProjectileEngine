extends ProjectileBehaviorDestroy
class_name ProjectileDestroyCollision

## Collision-based destroy behavior that destroys projectiles when collide with object

## Destroy when collide with an area
@export var destroy_on_area_collide: bool = true

## Destroy when collide with a body
@export var destroy_on_body_collide: bool = true


## Processes collision-based destroy behavior
func process_behavior(_value, _context: Dictionary) -> bool:
	if !destroy_on_area_collide or !destroy_on_body_collide:
		return false

	var projectile_owner = _context.get("projectile_owner")
	if not projectile_owner:
		return false
	projectile_owner = projectile_owner as Projectile2D
	
	if destroy_on_area_collide:
		if projectile_owner.has_overlapping_areas():
			return true
	if destroy_on_body_collide:
		if projectile_owner.has_overlapping_bodies():
			return true
	
	return false