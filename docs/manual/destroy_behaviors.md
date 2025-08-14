# Destroy Behaviors

[ProjectileBehaviorDestroy](manual/destroy_behaviors.md) is a [Projectile Behavior](manual/projectile_behaviors_overview.md) that define conditions under which a projectile should be destroyed.

## Components
- [ProjectileDestroyBoundary](#projectiledestroyboundary)
- [ProjectileDestroyCollision](#projectiledestroycollision)
- [ProjectileDestroyImmediate](#projectiledestroyimmediate)
- [ProjectileDestroyLifeDistance](#projectiledestroylifedistance)
- [ProjectileDestroyLifeTime](#projectiledestroylifetime)

## ProjectileDestroyBoundary
Destroys projectiles when they enter or leave a ProjectileBoundary2D.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Destroy On Enter | `destroy_on_enter` | bool | Whether to destroy when entering (true) or leaving (false) the boundary |
## ProjectileDestroyCollision
Destroys projectiles when they collide with an object.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Destroy On Area Collide | `destroy_on_area_collide` | bool | Destroy when colliding with an area |
| Destroy On Body Collide | `destroy_on_body_collide` | bool | Destroy when colliding with a body |
| Wait Projectile Piercing | `wait_projectile_piercing` | bool | Wait for piercing to complete |
| Wait Projectile Bouncing | `wait_projectile_bouncing` | bool | Wait for bouncing to complete |
## ProjectileDestroyImmediate
Destroys projectiles instantly when processed.
## ProjectileDestroyLifeDistance
Destroys projectiles after traveling a specified distance.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Destroy Distance | `destroy_distance` | float | Distance in pixels before destruction |
## ProjectileDestroyLifeTime
Destroys projectiles after a specified duration.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Destroy Time | `destroy_time` | float | Time in seconds before destruction |
---
[Back to Documentation Index](_sidebar.md)
