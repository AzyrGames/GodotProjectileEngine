# ProjectileSpawnMarker2D

Defines spawn locations and initial parameters for projectiles when used with [ProjectileSpawner2D](manual/projectile_spawner.md).

Provides precise control over projectile spawning through Marker2D's position.

## Properties
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `active` | `bool` | `true` | Whether this marker is active and will be used for spawning |s
| `use_global_position` | `bool` | `true` | Use global coordinates instead of local to spawner |
| `init_direction` | `Vector2` | `Vector2.RIGHT` | Initial movement direction for spawned projectiles |


## Notes
- Inherits Marker2D's transform properties for precise positioning
- Multiple markers can be added to a spawner for pattern variation
- Direction is normalized automatically during spawning

## Tips:
- use `ProjectileSpawnMarker2D` with `AnimationPlayer` to animate spawning position.

---
[Back to Projectile Spawner Documentation](manual/projectile_spawner.md)
