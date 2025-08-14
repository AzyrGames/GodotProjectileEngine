# ProjectileTemplateCustom2D
The ProjectileTemplateCustom2D class is a custom projectile template that allows for defining custom behaviors using ProjectileBehaviors. It extends the ProjectileTemplate2D class and provides the following properties:
- **damage**: Base damage dealt by the projectile.
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
It also provides arrays of ProjectileBehaviors to customize the projectile's behavior:
-   **speed_projectile_behaviors**: Array of ProjectileBehaviorSpeed to control the projectile's speed.
-   **direction_projectile_behaviors**: Array of ProjectileBehaviorDirection to control the projectile's direction.
-   **rotation_projectile_behaviors**: Array of ProjectileBehaviorRotation to control the projectile's rotation.
-   **scale_projectile_behaviors**: Array of ProjectileBehaviorScale to control the projectile's scale.
-   **destroy_projectile_behaviors**: Array of ProjectileBehaviorDestroy to control when the projectile is destroyed.
-   **piercing_projectile_behaviors**: Array of ProjectileBehaviorPiercing to control the projectile's piercing behavior.
-   **bouncing_projectile_behaviors**: Array of ProjectileBehaviorBouncing to control the projectile's bouncing behavior.
-   **trigger_projectile_behaviors**: Array of ProjectileBehaviorTrigger to control the projectile's trigger behavior.
It also provides random variation properties:
-   **speed_random**: Random variation for speed.
-   **texture_rotation_random**: Random variation for texture rotation.
-   **scale_random**: Random variation for scale.
---
[Back to Documentation Index](_sidebar.md)
