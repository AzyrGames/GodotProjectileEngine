# Projectile Engine Autoload
An Global Autoload for Godot Projectile Engine. Acts as the Singleton of the Godot Projectile Engine, coordinating between all components and providing global access to Projectile Engine.

## Key Responsibilities
- Maintains registries of active projectile components
- Provides global access to projectile systems
- Handles cross-component communication
- Manages projectile counting and cleanup
- Offers utility functions for projectile interactions

## Core Components
### 1. Manager Registries
- `projectile_updater_2d_nodes`: Tracks all active ProjectileUpdater2D instances
- `projectile_node_manager_2d_nodes`: Manages ProjectileNodeManager2D instances
- `pattern_composer_nodes`: Stores PatternComposer2D nodes
- `projectile_wrapper_2d_nodes`: Keeps track of ProjectileWrapper2D nodes

### 2. Enum Configurations
#### BehaviorContext
Defines context keys for behavior processing:
```gdscript
PHYSICS_DELTA        # Physics frame delta time
GLOBAL_POSITION      # Projectile's global position
PROJECTILE_OWNER     # Reference to projectile owner
BEHAVIOR_OWNER       # Behavior component owner
LIFE_TIME_TICK       # Current lifetime in ticks
# ... and 12 more contexts
```

#### Modification Enums
- `SpeedModify`: Add/Override/Multiply speed operations
- `DirectionModify`: Direction manipulation methods  
- `RotationModify`: Rotation adjustment types
- `ScaleModify`: Scale modification operations

## Key Properties
| Property | Type | Description |
|----------|------|-------------|
| active_projectile_count | int | Total active projectiles (instances + nodes) |
| active_projectile_instance_count | int | Active ProjectileInstance2D count |
| active_projectile_node_count | int | Active ProjectileNode2D count |
| projectile_environment | Node2D | Reference to active environment |
| projectile_boundary_2d | Area2D | Active boundary system |

## Essential Methods
### Projectile Management
```gdscript
refresh_projectile_engine()  # Resets engine to default state
clear_all_projectiles()      # Removes all active projectiles
get_projectile_instance()    # Retrieves instance by RID and index
```

### Component Control
```gdscript
activate_all_projectile_wrappers(name)  # Enables wrappers by group
deactivate_all_projectile_wrappers(name)# Disables wrappers by group
```

## Signals
### Trigger Events
```gdscript
projectile_instance_triggered(trigger_name, instance)
projectile_node_triggered(trigger_name, node)
```

### Collision Events
```gdscript
projectile_instance_body_shape_entered(instance, body_rid, body, shape_idx)
projectile_instance_area_shape_entered(instance, area_rid, area, shape_idx)
# ... plus 6 other collision signals
```

## Utility Functions
### Randomization
```gdscript
get_random_int_value(range: Vector3i) -> int
get_random_float_value(range: Vector3) -> float
```

### Group Management
```gdscript
get_valid_target_group_nodes(group_name) -> Array[Node2D]
```

## Example Usage
```gdscript
# Connect to trigger event
ProjectileEngine.projectile_instance_triggered.connect(
    func(trigger, instance):
        print("Triggered:", trigger, "by", instance)
)

# Get random speed value between 50-150 
var speed = ProjectileEngine.get_random_float_value(Vector3(100, 50, 1))
```

[Back to Projectile Overview](projectile_overview.md)
