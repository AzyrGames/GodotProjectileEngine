# PatternComposerComponent
Base class for all pattern composer components. These components define specific aspects of projectile patterns when used with PatternComposer2D.

## Core Component
- [PatternComposerComponent](#patterncomposercomponent) - Base class for all pattern composer components

### Properties
| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Active | `active` | bool | Whether the component is currently enabled |


## Components
- [PCCCustomShape2D](#pcccustomshape2d)
- [PCCCircle2D](#pccCircle2D)
- [PCCLoop](#pccloop)
- [PCCShape2D](#pccshape2d)
- [PCCSingle2D](#pccsingle2d)
- [PCCSpeedMod2D](#pccspeedmod2d)
- [PCCSpread2D](#pccspread2d)
- [PCCStack2D](#pccstack2d)

### PCCCustomShape2D
Generates positions based on a Curve2D resource:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Shape Path | `shape_path` | Curve2D | Resource defining the shape |
| Shape Sample Method | `shape_sample_method` | String | Sampling method (POINTS, BAKED_POINTS, etc) |
| Point Per Spawn | `point_per_spawn` | int | Points to spawn per data |
| Reset Per Spawn | `reset_per_spawn` | bool | Reset point index per spawn |
| Uniform Distance | `uniform_distance` | float | Distance between points |

### PCCCircle2D
Creates polygon-shaped patterns:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Radius | `radius` | float | Polygon radius |
| Polygon Sides | `polygon_sides` | int | Number of sides |
| Spread Out | `spread_out` | bool | Match texture rotation |
| Radius Random | `radius_random` | float | Radius variation |
| Polygon Sides Random | `polygon_sides_random` | float | Sides variation |

### PCCLoop
Repeats child components:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Loop Count | `loop_count` | int | Number of repetitions |

### PCCShape2D
Uses Shape2D resources:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Shape 2D | `shape_2d` | Shape2D | Collision shape |
| Shape Sample Method | `shape_sample_method` | String | Sampling method |

### PCCSingle2D
Controls direction/rotation:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Direction Type | `direction_type` | String | Processing type |
| Fixed Direction | `fixed_direction` | Vector2 | Fixed movement direction |
| Target Group | `target_group` | String | Target group name |

### PCCSpeedMod2D
Modifies projectile speed:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Modifier | `speed_modifier` | float | Speed multiplier |
| Speed Modifier Random | `speed_modifier_random` | float | Speed variation |

### PCCSpread2D
Creates projectile spreads:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Spread Type | `spread_type` | String | STRAIGHT/ANGLE/HYBRID |
| Spread Amount | `spread_amount` | int | Number of projectiles |
| Spread Distance | `spread_distance` | float | Distance between |

### PCCStack2D
Generates projectile stacks:

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Stack Amount | `stack_amount` | int | Projectiles per stack |
| Stack Distance | `stack_distance` | float | Spacing between |


---
[Back to Pattern Composer](pattern_composer.md)
