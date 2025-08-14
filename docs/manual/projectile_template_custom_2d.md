# ProjectileTemplateCustom2D
The ProjectileTemplateCustom2D class is a custom projectile template that allows for defining custom behaviors using ProjectileBehaviors. 

It extends the [ProjectileTemplate2D](manual/projectile_template.md) class and provides the following properties:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Damage | `damage` | float | Base damage dealt by the projectile |
| Speed | `speed` | float | Movement speed in pixels per second |
| Projectile Pooling Amount | `projectile_pooling_amount` | int | Number of projectiles to preload in object pool |
| Texture | `texture` | Texture2D | Projectile instance texture |
| Scale | `scale` | Vector2 | Projectile instance scale (default: 1.0, 1.0) |
| Texture Rotation | `texture_rotation` | float | Initial texture rotation in degrees (-360 to 360) |
| Skew | `skew` | float | Skew/shear effect (-89.9 to 89.9 degrees) |
| Texture Visible | `texture_visible` | bool | Toggles texture visibility |
| Texture Z Index | `texture_z_index` | int | Render layer for texture (higher=on top) |
| Texture Modulate | `texture_modulate` | Color | Color modulation (RGBA) |
| Collision Shape | `collision_shape` | Shape2D | Collision shape for physics detection |
| Collision Layer | `collision_layer` | int | Physics collision layers (bitmask) |
| Collision Mask | `collision_mask` | int | Physics collision detection mask (bitmask) |

**Projectile Behavior Arrays:**

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Behaviors | `speed_projectile_behaviors` | Array[[ProjectileBehaviorSpeed](/manual/speed_behaviors.md)] | Controls projectile speed behavior |
| Direction Behaviors | `direction_projectile_behaviors` | Array[[ProjectileBehaviorDirection](/manual/direction_behaviors.md)] | Controls projectile direction behavior |
| Rotation Behaviors | `rotation_projectile_behaviors` | Array[[ProjectileBehaviorRotation](/manual/rotation_behaviors.md)] | Controls projectile rotation behavior |
| Scale Behaviors | `scale_projectile_behaviors` | Array[[ProjectileBehaviorScale](/manual/scale_behaviors.md)] | Controls projectile scale behavior |
| Destroy Behaviors | `destroy_projectile_behaviors` | Array[[ProjectileBehaviorDestroy](/manual/destroy_behaviors.md)] | Controls projectile destruction conditions |
| Piercing Behaviors | `piercing_projectile_behaviors` | Array[[ProjectileBehaviorPiercing](/manual/piercing_behaviors.md)] | Controls projectile piercing behavior |
| Bouncing Behaviors | `bouncing_projectile_behaviors` | Array[[ProjectileBehaviorBouncing](/manual/bouncing_behaviors.md)] | Controls projectile bouncing behavior |
| Trigger Behaviors | `trigger_projectile_behaviors` | Array[[ProjectileBehaviorTrigger](/manual/trigger_behaviors.md)] | Controls projectile trigger behavior |

**Random Variation Properties:**

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Random | `speed_random` | Vector3 | Random variation for speed |
| Texture Rotation Random | `texture_rotation_random` | Vector3 | Random variation for texture rotation |
| Scale Random | `scale_random` | Vector3 | Random variation for scale |

---
[Back to Projectile Templates Overview](/manual/projectile_template_overview.md)
