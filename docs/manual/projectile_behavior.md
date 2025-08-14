# ProjectileBehavior

Projectile Behaviors are reusable [resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) components that define specific aspects of a projectile's behavior. They can be attached to [ProjectileTemplateCustom2D](manual/projectile_template.md#ProjectileTemplateCustom2D) or [ProjetileNode2D](manual/projectile_node_2d.md) to create custom projectile behaviors.

The [ProjectileBehavior](manual/projectile_behavior.md) Resource is the base Resource for all projectile behaviors in the Godot Projectile Engine. It provides core functionality and an interface that all behavior implementations must follow. 

Projectile Behavior can modify projectile properties, collision, destroy, trigger, and more. It provides various ways to customize the projectile to the designer's needs.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Active | `active` | bool | Whether the behavior is currently active |
| Behavior Values | `behavior_values` | Dictionary | Storage for behavior runtime data |

### Sample Methods
```gdscript
enum SampleMethod {
    LIFE_TIME_SECOND,  # Sample every physics frame based on time
    LIFE_DISTANCE      # Sample based on distance traveled
}
```

### Process Modes 
```gdscript
enum ProcessMode {
    PHYSICS,  # Process in _physics_process
    TICKS     # Process in _process
}
```

## Projectile Behaviors
- [Speed Behaviors](manual/speed_behaviors.md): Modifying projectile speed
- [Direction Behaviors](manual/direction_behaviors.md): Modifying projectile direction
- [Rotation Behaviors](manual/rotation_behaviors.md): Modifying projectile rotation
- [Scale Behaviors](manual/scale_behaviors.md): Modifying projectile scale
- [Destroy Behaviors](manual/destroy_behaviors.md): Conditions for destroying projectiles
- [Piercing Behaviors](manual/piercing_behaviors.md): Triggering actions based on conditions
- [Bouncing Behaviors](manual/bouncing_behaviors.md): How projectiles bounce off surfaces
- [Trigger Behaviors](manual/trigger_behaviors.md): Triggering actions based on conditions


---
[Back to Projectile Behaviors Overview](manual/projectile_behaviors_overview.md)
