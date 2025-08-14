# ProjectileTemplateNode2D
## Components
- [ProjectileTemplateNode2D](#projectiletemplatenode2d) - Base template for scene-based projectiles
- [Projectile2D](#projectile2d-properties) - Core implementation for custom projectile scenes
- [ProjectileLaser2D](#projectilelaser2d-properties) - Specialized laser beam implementation

The ProjectileTemplateNode2D class is a projectile template that uses a separate scene to define the projectile's appearance and behavior. It extends the ProjectileTemplate2D class and provides the following properties:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Projectile 2D Path | `projectile_2d_path` | StringName | Path to Projectile2D Scene |
| Projectile Pooling Amount | `projectile_pooling_amount` | int | Number of projectiles to preload in object pool |

## Projectile2D Properties
Core projectile properties defined in the Projectile2D scene:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Active | `active` | bool | Whether projectile is active |
| Speed | `speed` | float | Movement speed in pixels/second |
| Direction | `direction` | Vector2 | Initial movement direction |
| Texture Rotation | `texture_rotation` | float | Initial texture rotation in degrees |
| Collision Shape | `collision_shape` | CollisionShape2D | Collision shape for physics |

**Behavior Arrays:**

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Behaviors | `speed_projectile_behaviors` | Array[[ProjectileBehaviorSpeed](/manual/speed_behaviors.md)] | Speed modification behaviors |
| Direction Behaviors | `direction_projectile_behaviors` | Array[[ProjectileBehaviorDirection](/manual/direction_behaviors.md)] | Direction modification behaviors |
| Rotation Behaviors | `rotation_projectile_behaviors` | Array[[ProjectileBehaviorRotation](/manual/rotation_behaviors.md)] | Rotation modification behaviors |
| Scale Behaviors | `scale_projectile_behaviors` | Array[[ProjectileBehaviorScale](/manual/scale_behaviors.md)] | Scale modification behaviors |
| Destroy Behaviors | `destroy_projectile_behaviors` | Array[[ProjectileBehaviorDestroy](/manual/destroy_behaviors.md)] | Destruction condition behaviors |
| Piercing Behaviors | `piercing_projectile_behaviors` | Array[[ProjectileBehaviorPiercing](/manual/piercing_behaviors.md)] | Piercing behaviors |
| Bouncing Behaviors | `bouncing_projectile_behaviors` | Array[[ProjectileBehaviorBouncing](/manual/bouncing_behaviors.md)] | Bouncing behaviors |
| Trigger Behaviors | `trigger_projectile_behaviors` | Array[[ProjectileBehaviorTrigger](/manual/trigger_behaviors.md)] | Trigger behaviors |

**Random Variations:**

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Random | `speed_random` | Vector3 | Random speed variation (min/max) |
| Texture Rotation Random | `texture_rotation_random` | Vector3 | Random texture rotation variation |
| Scale Random | `scale_random` | Vector3 | Random scale variation |

## ProjectileLaser2D Properties
Extended properties for laser-type projectiles:

**Core Laser Settings:**

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Laser Type | `laser_type` | Enum (STRAIGHT, CURVY) | Type of laser beam |
| Start Full Length | `start_full_length` | bool | Initialize at full length |
| Laser Length | `laser_length` | float | Maximum laser length in pixels |
| Laser Width | `laser_width` | float | Width of laser beam |
| Collision Width | `collision_width` | float | Width of collision shape |

**Texture Settings:**

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Texture | `texture` | Texture2D | Laser beam texture |
| Gradient | `gradient` | Gradient | Color gradient for beam |
| Texture Mode | `texture_mode` | Line2D.LineTextureMode | Texture stretching/tiling |
| Width Curve | `width_curve` | Curve | Width variation along beam |
| Begin Cap | `begin_cap_mode` | Line2D.LineCapMode | Start cap style |
| End Cap | `end_cap_mode` | Line2D.LineCapMode | End cap style |
---
[Back to Documentation Index](_sidebar.md)
