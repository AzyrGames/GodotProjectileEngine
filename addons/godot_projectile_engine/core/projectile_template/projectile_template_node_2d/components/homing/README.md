# ProjectileComponentHoming

The ProjectileComponentHoming component provides homing functionality for projectiles, allowing them to track and steer toward targets.

## Overview

The homing system consists of:
- **ProjectileComponentHoming**: The main component that processes homing behaviors
- **ProjectileBehaviorHoming**: Base class for all homing behaviors
- **Concrete Homing Behaviors**: Specific implementations that can be used as resources

## Usage

### 1. Add the Homing Component

Add a `ProjectileComponentHoming` node as a child of your projectile:

```gdscript
# In your projectile scene
ProjectileTemplateNode2D
├── ProjectileComponentDirection
├── ProjectileComponentSpeed
├── ProjectileComponentHoming  # Add this
└── ... other components
```

### 2. Create Homing Behavior Resources

Create `.tres` resource files using the available homing behaviors:

#### Simple Homing (ProjectileHomingSimple)
```gdscript
# homing_to_player.tres
[gd_resource type="ProjectileHomingSimple" format=3]

[resource]
target_group = "player"
steer_speed = 3.0
homing_strength = 0.8
max_homing_distance = 500.0
```

#### Advanced Homing (ProjectileHomingTarget)
```gdscript
# advanced_homing.tres
[gd_resource type="ProjectileHomingTarget" format=3]

[resource]
target_type = 0  # GROUP
target_group = "enemies"
group_selection = 1  # NEAREST
steer_speed = 5.0
homing_modify_method = 0  # OVERRIDE
max_homing_distance = 300.0
min_homing_distance = 20.0
homing_strength = 1.0
```

### 3. Assign Behaviors to Component

In the ProjectileComponentHoming inspector, add your homing behavior resources to the `component_behaviors` array.

## Available Homing Behaviors

### ProjectileHomingSimple

A simple homing behavior that targets the nearest node in a specified group.

**Properties:**
- `target_group`: Name of the group to target (e.g., "player", "enemies")
- `steer_speed`: How fast the projectile turns toward target (radians/second)
- `homing_strength`: Strength of homing effect (0.0 to 1.0)
- `max_homing_distance`: Maximum distance for homing activation (0 = unlimited)

### ProjectileHomingTarget

Advanced homing behavior with multiple targeting options.

**Properties:**
- `target_type`: Type of target (GROUP, NODE, POSITION)
- `target_group`: Group name (when using GROUP type)
- `target_node_path`: Path to specific node (when using NODE type)
- `target_position`: Fixed position (when using POSITION type)
- `group_selection`: How to select from group (FIRST, NEAREST, RANDOM)
- `steer_speed`: Steering speed (radians/second)
- `homing_modify_method`: How homing affects direction (OVERRIDE, ADDITION, MULTIPLICATION)
- `max_homing_distance`: Maximum homing range
- `min_homing_distance`: Minimum distance to prevent orbiting
- `homing_strength`: Effect strength (0.0 to 1.0)

## Target Setup

For group-based homing to work, ensure your target nodes are added to the appropriate groups:

```gdscript
# In your player/enemy script
func _ready():
    add_to_group("player")  # or "enemies", etc.
```

## Creating Custom Homing Behaviors

To create custom homing behaviors, extend `ProjectileBehaviorHoming`:

```gdscript
extends ProjectileBehaviorHoming
class_name MyCustomHoming

@export var custom_property: float = 1.0

func _request_behavior_context() -> Array[ProjectileEngine.BehaviorContext]:
    return [ProjectileEngine.BehaviorContext.PHYSICS_DELTA]

func process_behavior(_value: Vector2, _context: Dictionary) -> Array:
    # Your custom homing logic here
    # Return [new_direction] or [new_direction, rotation, addition]
    return [_value]
```

## Integration with Other Components

The homing component works by modifying the direction component. Ensure your projectile has:
- `ProjectileComponentDirection`: Required for homing to work
- `ProjectileComponentSpeed`: For movement
- Other components as needed

## Performance Considerations

- Use `max_homing_distance` to limit expensive distance calculations
- Consider using `ProjectileHomingSimple` for better performance when advanced features aren't needed
- Group-based targeting is more efficient than node path targeting for multiple projectiles
