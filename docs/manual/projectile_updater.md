# ProjectileUpdater2D 

Base class for update, physics interactions, and rendering [ProjectileInstance2D](/manual/projectile_instance.md)

## Properties

| Name | Variable Name | Type | Description |
|------|---------------|------|-------------|
| Projectile Template | `projectile_template_2d` | `ProjectileTemplate2D` | Associated template configuration |
| Base Speed | `projectile_speed` | `float` | Base movement speed |
| Collision Layer | `projectile_collision_layer` | `int` | Physics collision layer bits |
| Collision Mask | `projectile_collision_mask` | `int` | Physics collision mask bits |
| Max Pooling | `projectile_max_pooling` | `int` | Maximum pooled projectile instances |
| Instance Array | `projectile_instance_array` | `Array[ProjectileInstance2D]` | All pooled instances |
| Active Indices | `projectile_active_index` | `Array[int]` | Indices of active projectiles |

## Key Methods
- `setup_projectile_updater()` - Initializes collision and pooling systems  
- `update_projectile_instances(delta: float)` - Main physics processing
- `draw_projectile_texture()` - Handles visual rendering
- `clear_projectile_updater()` - Cleans up resources
- Collision callbacks (`_area_monitor_callback`, `_body_monitor_callback`)

## Subclasses

### ProjectileUpdaterSimple2D
Simplified updater for basic projectile movement and lifecycle management

**Properties**:

| Variable Name | Type | Description |
|---------------|------|-------------|
| `projectile_velocity` | `Vector2` | Current velocity vector |
| `projectile_life_time_second_max` | `float` | Maximum lifetime in seconds |
| `projectile_life_distance_max` | `float` | Maximum travel distance |
| `destroy_on_body_collide` | `bool` | Destroy on physics body collision |
| `destroy_on_area_collide` | `bool` | Destroy on area collision |
| `projectile_texture_rotate_direction` | `bool` | Rotate texture to match movement direction |

**Key Features**:
- Basic movement with velocity
- Life time/distance expiration
- Collision destruction handling
- Texture rotation alignment

### ProjectileUpdaterAdvanced2D
Advanced updater with homing, rotation, scaling, and trigger capabilities

**Properties**:

| Variable Name | Type | Description |
|---------------|------|-------------|
| `projectile_speed_acceleration` | `float` | Speed change per second |
| `projectile_speed_max` | `float` | Maximum speed limit |
| `projectile_is_use_homing` | `bool` | Enable homing behavior |
| `projectile_homing_target_group` | `String` | Group name for homing targets |
| `projectile_rotation_speed` | `float` | Degrees per second rotation |
| `projectile_scale_acceleration` | `float` | Scale change per second |
| `projectile_scale_max` | `Vector2` | Maximum scale limit |
| `projectile_is_use_trigger` | `bool` | Enable trigger behaviors |

**Key Features**:
- Homing missile functionality
- Rotational velocity
- Dynamic scaling over time
- Event triggers at set intervals
- Speed acceleration/clamping

### ProjectileUpdaterCustom2D
Customizable updater using [Projectile Behavior](manual/projectile_behaviors_overview.md) for more complex projectile logic

**Properties**:

| Variable Name | Type | Description |
|---------------|------|-------------|
| `behavior_values` | `Dictionary` | Active behavior configurations |
| `projectile_behaviors` | `Array[ProjectileBehavior]` | Attached behavior scripts |

**Key Features**:
- Modular behavior system
- Real-time parameter modifications
- Combined speed/direction/rotation/scale behaviors
- Custom collision responses
- Event-driven triggers
