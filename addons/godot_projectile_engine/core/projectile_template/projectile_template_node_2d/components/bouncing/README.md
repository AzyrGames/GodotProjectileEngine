# ProjectileComponentBouncing

A comprehensive bouncing system for the Godot Projectile Engine that provides realistic collision detection, reflection calculations, and customizable bounce behaviors.

## Overview

The bouncing system consists of two main parts:
- **ProjectileComponentBouncing**: The component that handles bounce logic using existing Area2D collision detection
- **ProjectileBehaviorBouncing**: Resource-based behaviors that define how projectiles should bounce

## Features

### Collision Detection Integration
- **Uses Existing Area2D**: Integrates with Projectile2D's built-in Area2D collision system
- **Body Collision**: Bounces off physics bodies (StaticBody2D, RigidBody2D, CharacterBody2D)
- **Area Collision**: Optional bouncing off other Area2D nodes

### Bounce Types
- **Perfect Reflection**: Elastic collision with no energy loss
- **Dampened Reflection**: Realistic energy loss over time
- **Random Reflection**: Unpredictable bouncing within a cone
- **Surface Absorption**: Material-based energy absorption
- **Velocity Dependent**: Bounce behavior changes with impact speed

### Surface Materials
- **Metal**: High reflection (95% energy retention)
- **Rubber**: High bounce (85% energy retention)
- **Wood**: Medium bounce (65% energy retention)
- **Concrete**: Low bounce (45% energy retention)
- **Water**: Very low bounce (25% energy retention)
- **Custom**: User-defined values

## Basic Usage

### 1. Add the Component

Add `ProjectileComponentBouncing` to your projectile scene:

```gdscript
# In your projectile scene
extends Node2D

func _ready():
    var bouncing_component = ProjectileComponentBouncing.new()
    add_child(bouncing_component)
```

### 2. Configure Basic Settings

```gdscript
# Configure the bouncing component
bouncing_component.max_bounces = 5  # Maximum number of bounces
bouncing_component.bounce_energy_retention = 0.8  # Energy kept per bounce
bouncing_component.bounce_on_body_entered = true  # Bounce off physics bodies
bouncing_component.bounce_on_area_entered = false  # Don't bounce off other areas
bouncing_component.min_bounce_speed = 10.0  # Minimum speed to continue bouncing
```

### 3. Add Bouncing Behaviors

```gdscript
# Create a rubber ball behavior
var rubber_behavior = RubberBallBounce.new()
bouncing_component.component_behaviors.append(rubber_behavior)

# Or create a custom behavior
var custom_behavior = ProjectileBehaviorBouncing.new()
custom_behavior.bounce_type = ProjectileBehaviorBouncing.BounceType.DAMPENED_REFLECTION
custom_behavior.surface_material = ProjectileBehaviorBouncing.SurfaceMaterial.METAL
custom_behavior.energy_retention = 0.9
bouncing_component.component_behaviors.append(custom_behavior)
```

## Advanced Configuration

### Custom Bounce Behavior

```gdscript
# Create a highly customized bouncing behavior
var advanced_behavior = ProjectileBehaviorBouncing.new()

# Set bounce type and material
advanced_behavior.bounce_type = ProjectileBehaviorBouncing.BounceType.RANDOM_REFLECTION
advanced_behavior.surface_material = ProjectileBehaviorBouncing.SurfaceMaterial.CUSTOM
advanced_behavior.energy_retention = 0.75

# Configure randomness
advanced_behavior.reflection_cone_angle = 30.0
advanced_behavior.use_random_seed = true
advanced_behavior.random_seed = 12345

# Enable advanced features
advanced_behavior.velocity_dependent_loss = true
advanced_behavior.velocity_loss_factor = 0.1
advanced_behavior.angle_dependent_bounce = true
advanced_behavior.min_surface_angle = 15.0
advanced_behavior.enable_spin_effects = true
advanced_behavior.spin_factor = 0.5

# Set velocity thresholds
advanced_behavior.min_bounce_velocity = 20.0
advanced_behavior.max_bounce_velocity = 1000.0

# Configure bounce count dependency
advanced_behavior.bounce_count_dependency = true
advanced_behavior.energy_loss_per_bounce = 0.05
```

### Collision Type Configuration

```gdscript
# Enable/disable bouncing on different collision types
bouncing_component.bounce_on_body_entered = true   # Bounce off StaticBody2D, RigidBody2D, etc.
bouncing_component.bounce_on_area_entered = false  # Don't bounce off other Area2D nodes

# You can also change these at runtime
bouncing_component.set_bounce_on_body_entered(true)
bouncing_component.set_bounce_on_area_entered(false)

# Manual bounce triggering (for custom collision detection)
bouncing_component.trigger_bounce(collision_point, collision_normal, collider)
```

### Signal Handling

```gdscript
# Connect to bouncing signals
bouncing_component.projectile_bounced.connect(_on_projectile_bounced)
bouncing_component.max_bounces_reached.connect(_on_max_bounces_reached)

func _on_projectile_bounced(collision_point: Vector2, collision_normal: Vector2, bounce_count: int):
    print("Bounced at ", collision_point, " with normal ", collision_normal)
    print("Bounce count: ", bounce_count)
    
    # Add visual effects, sound, etc.
    create_bounce_effect(collision_point)

func _on_max_bounces_reached(bounce_count: int):
    print("Maximum bounces reached: ", bounce_count)
    # Destroy projectile or change behavior
```

## Preset Behaviors

The system includes several preset behaviors for common use cases:

### RubberBallBounce
```gdscript
var rubber_ball = RubberBallBounce.new()
# High energy retention with slight randomness
# Perfect for bouncing ball effects
```

### MetalRicochetBounce
```gdscript
var ricochet = MetalRicochetBounce.new()
# High energy retention with spin effects
# Perfect for bullet ricochets
```

### ChaoticBounce
```gdscript
var chaos = ChaoticBounce.new()
# Unpredictable bouncing with large random cone
# Perfect for magical projectiles
```

### Using Static Presets
```gdscript
# Create preset behaviors using the static method
var rubber_preset = ProjectileBehaviorBouncing.create_preset("rubber_ball")
var metal_preset = ProjectileBehaviorBouncing.create_preset("metal_ricochet")
var chaotic_preset = ProjectileBehaviorBouncing.create_preset("chaotic_bounce")
var water_preset = ProjectileBehaviorBouncing.create_preset("water_splash")
var high_energy_preset = ProjectileBehaviorBouncing.create_preset("high_energy")
```

## Integration with Other Components

The bouncing component works seamlessly with other projectile components:

```gdscript
# Requires ProjectileComponentDirection for direction management
# Requires ProjectileComponentSpeed for speed management
# Optional: ProjectileComponentDestroy for automatic cleanup

# The component automatically finds and uses these components:
var direction_component = get_component("projectile_component_direction")
var speed_component = get_component("projectile_component_speed")
var destroy_component = get_component("projectile_component_destroy")
```

## Performance Considerations

The bouncing system uses the existing Area2D collision detection, so performance is primarily determined by:
- **Collision Layer Setup**: Only check necessary layers to reduce collision checks
- **Bounce Limits**: Set reasonable `max_bounces` to prevent infinite bouncing
- **Behavior Complexity**: Simpler behaviors (like Perfect Reflection) are faster than complex ones

## Tips and Best Practices

1. **Energy Management**: Set `min_bounce_speed` to prevent infinite micro-bounces
2. **Bounce Limits**: Use `max_bounces` to prevent performance issues
3. **Collision Setup**: Configure the Projectile2D's Area2D collision layers properly
4. **Visual Feedback**: Connect to bounce signals for effects and audio
5. **Testing**: Use different surface materials to find the right feel for your game
6. **Component Integration**: Ensure direction and speed components are present

## Troubleshooting

### Projectile Not Bouncing
- Check that `bounce_on_body_entered` is true for physics body collisions
- Verify the Projectile2D's Area2D collision mask includes target layers
- Ensure direction and speed components are present and working
- Check that the projectile has sufficient speed (`min_bounce_speed`)
- Verify that collision shapes are properly configured on both projectile and targets

### Infinite Bouncing
- Set a reasonable `max_bounces` value
- Increase `min_bounce_speed` threshold
- Enable `destroy_on_low_speed`
- Use `bounce_count_dependency` for gradual energy loss
- Check for collision shape overlaps that might cause repeated bouncing

### Performance Issues
- Optimize collision layers on the Projectile2D's Area2D
- Reduce `max_bounces` to limit bounce calculations
- Use simpler bounce behaviors for better performance
- Consider pooling projectiles instead of creating new ones
- Disable `bounce_on_area_entered` if not needed
