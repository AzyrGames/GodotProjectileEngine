# Projectile Behaviors Overview
Projectile Behaviors are reusable [resource](https://docs.godotengine.org/en/stable/classes/class_resource.html) components that define specific aspects of a projectile's behavior. They can be attached to [ProjectileTemplateCustom2D](manual/projectile_instance.md#ProjectileInstanceCustom2D) or [ProjetileNode2D](manual/projectile_node_2d.md) to create custom projectile behaviors.

The [ProjectileBehavior](manual/projectile_behavior.md) Resource is the base Resource for all projectile behaviors in the projectile engine. It provides core functionality and an interface that all behavior implementations must follow. 

Projectile Behaviors modify projectile properties. Provides various ways to customize the projectile to the designer's needs.
## Projectile Behaviors
- [Destroy Behaviors](destroy_behaviors.md): Conditions for destroying projectiles
- [Bouncing Behaviors](bouncing_behaviors.md): How projectiles bounce off surfaces
- [Direction Behaviors](direction_behaviors.md): Modifying projectile direction
- [Life Distance Behaviors](life_distance_behaviors.md): Destroying after distance traveled
- [Life Time Behaviors](life_time_behaviors.md): Destroying after time elapsed
- [Rotation Behaviors](rotation_behaviors.md): Modifying projectile rotation
- [Scale Behaviors](scale_behaviors.md): Modifying projectile scale
- [Speed Behaviors](speed_behaviors.md): Modifying projectile speed
- [Trigger Behaviors](trigger_behaviors.md): Triggering actions based on conditions

---
[Back to Documentation Index](_sidebar.md)
