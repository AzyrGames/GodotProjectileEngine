# Destroy Behaviors
## Components
- [ProjectileDestroyBoundary](#projectiledestroyboundary)
- [ProjectileDestroyCollision](#projectiledestroycollision)
- [ProjectileDestroyImmediate](#projectiledestroyimmediate)
- [ProjectileDestroyLifeDistance](#projectiledestroylifedistance)
- [ProjectileDestroyLifeTime](#projectiledestroylifetime)
Destroy behaviors define conditions under which a projectile should be destroyed.
## ProjectileDestroyBoundary
Destroys projectiles when they enter or leave a ProjectileBoundary2D.
## Properties
- **destroy_on_enter**: Whether to destroy when entering (true) or leaving (false) the boundary
## ProjectileDestroyCollision
Destroys projectiles when they collide with an object.
## Properties
- **destroy_on_area_collide**: Destroy when colliding with an area
- **destroy_on_body_collide**: Destroy when colliding with a body
- **wait_projectile_piercing**: Wait for piercing to complete
- **wait_projectile_bouncing**: Wait for bouncing to complete
## ProjectileDestroyImmediate
Destroys projectiles instantly when processed.
## ProjectileDestroyLifeDistance
Destroys projectiles after traveling a specified distance.
## Properties
- **destroy_distance**: Distance in pixels before destruction
## ProjectileDestroyLifeTime
Destroys projectiles after a specified duration.
## Properties
- **destroy_time**: Time in seconds before destruction
---
[Back to Documentation Index](_sidebar.md)
