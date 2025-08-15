# ProjectileTemplate2D
A base Resource for all 2D projectile templates. Provides core functionality that all projectile templates inherit.


## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Custom Data | `custom_data` | Array[Variant] | Array for storing custom template data |

## Projectile Templates

### ProjectileTemplateSimple2D

The ProjectileTemplateSimple2D Resource is a simple projectile template that defines projectiles that only go in a straight line.

When spawned, it will create new or activate a [ProjectileInstanceSimple2D](/manual/projectile_instance.md#ProjectileInstanceSimple2D)

#### Properties:
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

### ProjectileTemplateAdvanced2D

The ProjectileTemplateAdvanced2D Resource is an advanced projectile template that defines projectiles that can accelerate, rotate, homing, and trigger.

When spawned, it will create new or activate a [ProjectileInstanceAdvanced2D](/manual/projectile_instance.md#ProjectileInstanceAdvanced2D)


#### Core Properties:
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

**Random Variation Properties:**

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


### ProjectileTemplateCustom2D
The ProjectileTemplateCustom2D class is a custom projectile template that allows for defining custom projectiles using [Projectile Behaviors](manual/projectile_behavior.md).

When spawned, it will create new or activate a [ProjectileInstanceCustom2D](/manual/projectile_instance.md#ProjectileInstanceCustom2D)


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


### ProjectileTemplateNode2D

The ProjectileTemplateNode2D Resource is a projectile template that spawns [ProjectileNode2D](/manual/projectile_node_2d.md) using scene path or UID.

#### Properties:
| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Projectile 2D Path | `projectile_2d_path` | StringName | Path to Projectile2D Scene |
| Projectile Pooling Amount | `projectile_pooling_amount` | int | Number of projectiles to preload in object pool |

---
[Back to Projectile Templates Overview](/manual/projectile_template_overview.md)
