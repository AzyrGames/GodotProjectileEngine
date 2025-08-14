# ProjectileTemplateSimple2D
The ProjectileTemplateSimple2D class is a simple projectile template that defines a projectile with basic properties. It extends the ProjectileTemplate2D class and provides the following properties:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
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
| Texture Rotate Direction | `texture_rotate_direction` | bool | Rotate texture with movement direction |
| Destroy on Body Collide | `destroy_on_body_collide` | bool | Destroy on body collision |
| Destroy on Area Collide | `destroy_on_area_collide` | bool | Destroy on area collision |
| Max Lifetime | `life_time_second_max` | float | Maximum lifetime in seconds (<0 = infinite) |
| Max Life Distance | `life_distance_max` | float | Maximum travel distance in pixels (<0 = infinite) |

**Random Variation Properties:**

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Random | `speed_random` | Vector3 | Random variation for speed |
| Texture Rotation Random | `texture_rotation_random` | Vector3 | Random variation for texture rotation |
| Texture Rotation Speed Random | `texture_rotation_speed_random` | Vector3 | Random variation for texture rotation speed |
| Scale Random | `scale_random` | Vector3 | Random variation for scale |
| Lifetime Random | `life_time_second_random` | Vector3 | Random variation for lifetime |
| Life Distance Random | `life_distance_random` | Vector3 | Random variation for life distance |
---
[Back to Documentation Index](_sidebar.md)
