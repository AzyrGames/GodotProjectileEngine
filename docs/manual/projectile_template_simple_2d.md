# ProjectileTemplateSimple2D
The ProjectileTemplateSimple2D class is a simple projectile template that defines a projectile with basic properties. It extends the ProjectileTemplate2D class and provides the following properties:
- **speed**: The movement speed of the projectile in pixels per second.
- **projectile_pooling_amount**: The number of projectiles to preload in the object pool for better performance.
- **texture**: The Projectile Instance Texture.
- **scale**: The Projectile Instance Scale.
- **texture_rotation**: The initial rotation of the texture in degrees.
- **skew**: Skew/shear effect applied to texture (-89.9 to 89.9 degrees).
- **texture_visible**: Toggles visibility of the projectile's texture.
- **texture_z_index**: Render layer for the texture (higher values render on top).
- **texture_modulate**: Color modulation applied to the texture (RGBA).
- **collision_shape**: Collision shape used for physics detection.
- **collision_layer**: Physics layers this projectile can collide with (bitmask).
- **collision_mask**: Physics layers that can detect collisions with this projectile (bitmask).
- **texture_rotate_direction**: Rotate texture with direction
- **destroy_on_body_collide**: Destroy when collided with a body.
- **destroy_on_area_collide**: Destroy when collided with a area.
- **life_time_second_max**: Maximum lifetime of projectile in seconds before it's automatically destroyed.
- **life_distance_max**: Maximum travel distance in pixels before projectile is automatically destroyed.
It also provides random variation properties:
-   **speed_random**: Random variation for speed.
-   **texture_rotation_random**: Random variation for texture rotation.
-   **texture_rotation_speed_random**: Random variation for texture rotation speed.
-   **scale_random**: Random variation for scale.
-   **life_time_second_random**: Random variation for lifetime.
-   **life_distance_random**: Random variation for life distance.
---
[Back to Documentation Index](_sidebar.md)
