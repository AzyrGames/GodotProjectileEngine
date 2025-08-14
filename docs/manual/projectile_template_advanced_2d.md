# ProjectileTemplateAdvanced2D
The ProjectileTemplateAdvanced2D class is an advanced projectile template that provides more projectile behavior options. It extends the ProjectileTemplate2D class and provides the following properties:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed | `speed` | float | Movement speed in pixels per second |
| Projectile Pooling Amount | `projectile_pooling_amount` | int | Number of projectiles to preload in object pool |
| Texture | `texture` | Texture2D | Projectile instance texture |
| Scale | `scale` | Vector2 | Projectile instance scale |
| Texture Rotation | `texture_rotation` | float | Initial texture rotation in degrees |
| Skew | `skew` | float | Skew/shear effect (-89.9 to 89.9 degrees) |
| Texture Visible | `texture_visible` | bool | Toggles texture visibility |
| Texture Z Index | `texture_z_index` | int | Render layer for texture |
| Texture Modulate | `texture_modulate` | Color | Color modulation (RGBA) |
| Collision Shape | `collision_shape` | Shape2D | Collision shape for physics detection |
| Collision Layer | `collision_layer` | int | Physics layers for collisions (bitmask) |
| Collision Mask | `collision_mask` | int | Physics layers to detect collisions (bitmask) |
| Speed Acceleration | `speed_acceleration` | float | Acceleration rate (units/sec²) |
| Max Speed | `speed_max` | float | Maximum speed (units/sec) |
| Direction Rotation | `direction_rotation` | float | Initial direction in degrees |
| Direction Rotation Speed | `direction_rotation_speed` | float | Rotation speed of direction (degrees/sec) |
| Direction Follow Rotation | `direction_follow_rotation` | bool | Match direction to texture rotation |
| Texture Rotation Speed | `texture_rotation_speed` | float | Rotation speed of texture (degrees/sec) |
| Rotation Follow Direction | `rotation_follow_direction` | bool | Match texture rotation to direction |
| Scale Acceleration | `scale_acceleration` | float | Acceleration rate for scale (units/sec²) |
| Max Scale | `scale_max` | Vector2 | Maximum scale the projectile can reach (as Vector2) |
| Use Homing | `is_use_homing` | bool | Enable target homing behavior |
| Target Group | `target_group` | String | Group name to target |
| Steer Speed | `steer_speed` | float | Steering speed (radians/sec) |
| Homing Strength | `homing_strength` | float | Homing effect strength (0.0-1.0) |
| Max Homing Distance | `max_homing_distance` | float | Maximum active homing distance (0=unlimited) |
| Destroy on Body Collide | `destroy_on_body_collide` | bool | Destroy on body collision |
| Destroy on Area Collide | `destroy_on_area_collide` | bool | Destroy on area collision |
| Max Lifetime | `life_time_second_max` | float | Maximum lifetime in seconds |
| Max Life Distance | `life_distance_max` | float | Maximum travel distance in pixels |
| Use Trigger | `is_use_trigger` | bool | Enable trigger events |
| Trigger Name | `trigger_name` | String | Name of the trigger to activate |
| Trigger Amount | `trigger_amount` | int | Amount of trigger to activate |
| Trigger Life Time | `trigger_life_time` | float | Trigger lifetime duration (seconds) |
| Trigger Life Distance | `trigger_life_distance` | float | Trigger lifetime distance (pixels) |

It also provides random variation properties:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Random | `speed_random` | Vector3 | Random variation for speed |
| Speed Acceleration Random | `speed_acceleration_random` | Vector3 | Random variation for speed acceleration |
| Max Speed Random | `speed_max_random` | Vector3 | Random variation for maximum speed |
| Texture Rotation Random | `texture_rotation_random` | Vector3 | Random variation for texture rotation |
| Texture Rotation Speed Random | `texture_rotation_speed_random` | Vector3 | Random variation for texture rotation speed |
| Direction Rotation Random | `direction_rotation_random` | Vector3 | Random variation for direction rotation |
| Direction Rotation Speed Random | `direction_rotation_speed_random` | Vector3 | Random variation for direction rotation speed |
| Scale Random | `scale_random` | Vector3 | Random variation for scale |
| Max Scale Random | `scale_max_random` | Vector3 | Random variation for maximum scale |
| Scale Acceleration Random | `scale_acceleration_random` | Vector3 | Random variation for scale acceleration |
| Lifetime Random | `life_time_second_random` | Vector3 | Random variation for lifetime |
| Life Distance Random | `life_distance_random` | Vector3 | Random variation for life distance |
---
[Back to Documentation Index](_sidebar.md)
