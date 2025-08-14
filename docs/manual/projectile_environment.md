# Projectile Environment 2D
Central management node for all projectile-related systems. Acts as a singleton that coordinates projectile interactions and physics.

![Environment Icon](assets/icons/environment_icon.svg)

## Key Responsibilities
- Manages projectile updater instances
- Handles collision detection and response
- Provides damage value lookup
- Coordinates bouncing physics
- Maintains projectile system state

## Core Methods

### Lifecycle Management
```gdscript
_enter_tree()  # Registers as main environment
_exit_tree()   # Cleans up environment
```

### Collision Handling
```gdscript
projectile_collided(rid: RID, shape_idx: int)  # Processes collision events
spawner_destroyed(rid: RID)                   # Handles spawner cleanup
```

### Damage System
```gdscript
get_projectile_damage(rid: RID) -> int  # Returns damage for projectile RID
```

### Physics Helpers
```gdscript
request_bouncing_helper(shape: Shape2D)  # Creates collision helper for bouncing
```

## Usage
```gdscript
# Typical setup in main scene
var environment = ProjectileEnvironment2D.new()
add_child(environment)
```

## Relationships
- Manages all [ProjectileUpdater2D](projectile_updater.md) instances
- Integrates with [ProjectileSpawner2D](projectile_spawner.md) systems
- Utilized by [ProjectileBehavior](projectile_behavior.md) implementations

[Back to Projectile Overview](projectile_overview.md)
