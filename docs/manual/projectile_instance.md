# Projectile Instance 2D

## ProjectileInstance2D

Base [Object](https://docs.godotengine.org/en/stable/classes/class_object.html) for all 2D projectile instances.

### Properties
| Name | Variable Name | Type | Description |
|------|---------------|------|-------------|
| Projectile Updater | `projectile_updater` | `ProjectileUpdater2D` | Reference to updater component |
| Area RID | `area_rid` | `RID` | Physics server RID for collision area |
| Speed | `speed` | `float` | Current movement speed |
| Direction | `direction` | `Vector2` | Base movement direction (default: `Vector2.RIGHT`) |
| Velocity | `velocity` | `Vector2` | Calculated movement velocity |
| Global Position | `global_position` | `Vector2` | World position |
| Texture Rotation | `texture_rotation` | `float` | Visual rotation |
| Scale | `scale` | `Vector2` | Visual scale |
| Life Time (Seconds) | `life_time_second` | `float` | Current lifetime in seconds |
| Max Life Time | `life_time_second_max` | `float` | Maximum lifetime duration |
| Custom Data | `custom_data` | `Array[Variant]` | Custom user data storage |

## ProjectileInstanceSimple2D

Simple projectile instance with minimal properties (inherits all properties from [ProjectileInstance2D](#ProjectileInstance2D)).

Using [ProjectileUpdaterSimple2D](/manual/projectile_updater.md#ProjectileUpdaterSimple2D) to update. 


## ProjectileInstanceAdvanced2D

Advanced projectile instance with acceleration, rotation controls, homing and triggers. 

Using [ProjectileUpdaterAdvanced2D](/manual/projectile_updater.md#ProjectileUpdaterAdvanced2D) to update.

### Additional Properties
| Name | Variable Name | Type | Description |
|------|---------------|------|-------------|
| Base Speed | `base_speed` | `float` | Initial movement speed |
| Max Speed | `speed_max` | `float` | Maximum allowed speed |
| Speed Acceleration | `speed_acceleration` | `float` | Acceleration rate |
| Direction Rotation Speed | `direction_rotation_speed` | `float` | Direction rotation speed (radians/sec) |
| Texture Rotation Speed | `texture_rotation_speed` | `float` | Visual rotation speed |
| Scale Acceleration | `scale_acceleration` | `float` | Scale change rate |
| Max Scale | `scale_max` | `Vector2` | Maximum scale size |

## ProjectileInstanceCustom2D

Customizable projectile instance with projectile behaviors.
Using [ProjectileUpdaterCustom2D](/manual/projectile_updater.md#ProjectileUpdaterCustom2D) to update.


### Additional Properties
| Name | Variable Name | Type | Description |
|------|---------------|------|-------------|
| Behavior Context | `behavior_context` | `Dictionary` | Behavior configuration storage |
| Base Direction Rotation | `base_direction_rotation` | `float` | Initial direction angle offset |
| Speed Clamp | `speed_clamp` | `Vector2` | Min/max speed boundaries |
| Direction Rotation Speed | `direction_rotation_speed` | `float` | Dynamic direction rotation |
| Projectile Speed | `projectile_speed` | `float` | Current modified speed |
| Projectile Rotation | `projectile_rotation` | `float` | Current modified rotation |
| Trigger Count | `trigger_count` | `int` | Number of times triggered |
