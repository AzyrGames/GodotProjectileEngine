# Pattern Composer Components
## Components
- [PCCCustomShape2D](#pcccustomshape2d)
- [PCCGroup](#pccgroup)
- [PCCPolygon2D](#pccpolygon2d)
- [PCCLoop](#pccloop)
- [PCCShape2D](#pccshape2d)
- [PCCSingle2D](#pccsingle2d)
- [PCCSpeedMod2D](#pccspeedmod2d)
- [PCCSpread2D](#pccspread2d)
- [PCCStack2D](#pccstack2d)
Pattern Composer Components are nodes that define specific aspects of a projectile pattern. They are used by the PatternComposer2D node to generate complex and interesting projectile patterns.
## PCCCustomShape2D
The `PCCCustomShape2D` component generates projectile positions based on a Curve2D resource.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Shape Path | shape_path | Curve2D | Resource defining the shape |
| Shape Sample Method | shape_sample_method | String | Method to sample points (POINTS, BAKED_POINTS, INSIDE_RANDOM, PERIMETER_RANDOM, PERIMETER_UNIFORM_DISTANCE) |
| Point Per Spawn | point_per_spawn | int | Number of points to spawn per pattern composer data |
| Reset Per Spawn | reset_per_spawn | bool | Reset the point index per spawn |
| Uniform Distance | uniform_distance | float | Distance between points for uniform sampling |
## PCCGroup
The `PCCGroup` component groups other PatternComposerComponent nodes together. It extends the `PatternComposerComponent` class and processes each child component in sequence.
## PCCPolygon2D
The `PCCPolygon2D` component generates projectile positions in a polygon shape.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Radius | radius | float | Radius of the polygon |
| Polygon Sides | polygon_sides | int | Number of sides of the polygon |
| Spread Out | spread_out | bool | Rotate direction to match texture rotation |
| Radius Random | radius_random | float | Random variation for radius |
| Polygon Sides Random | polygon_sides_random | float | Random variation for polygon sides |
## PCCLoop
The `PCCLoop` component loops through all child Pattern Composer Components a number of times.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Loop Count | loop_count | int | Number of times to loop through child components |
## PCCShape2D
The `PCCShape2D` component generates projectile positions based on a Shape2D resource.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Shape 2D | shape_2d | Shape2D | Resource defining the shape |
| Shape Sample Method | shape_sample_method | String | Method to sample points (INSIDE_RANDOM, PERIMETER_RANDOM) |
## PCCSingle2D
The `PCCSingle2D` component sets the direction and rotation for each incoming PatternComposerData.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Direction Type | direction_type | String | Type of direction processing |
| Fixed Direction | fixed_direction | Vector2 | Normalized fixed direction |
| Target Group | target_group | String | Target group name |
| Group Selection | group_selection | String | Group node selection method |
| Direction Rotation | direction_rotation | float | Rotation angle in degrees |
| Rotation Speed | rotation_speed | float | Rotation speed in degrees |
| Target Groups | target_groups | Array[String] | Array of target group names |
## PCCSpeedMod2D
The `PCCSpeedMod2D` component modifies the speed of projectiles. It extends the `PatternComposerComponent` class.
## PCCSpread2D
The `PCCSpread2D` component generates a spread of projectiles.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Spread Type | spread_type | String | Type of spread (STRAIGHT, ANGLE, HYBRID) |
| Spread Amount | spread_amount | int | Number of projectiles in the spread |
| Spread Distance | spread_distance | float | Distance between projectiles in straight spread |
| Spread Angle | spread_angle | float | Angle between projectiles in angle spread |
| Spread Amount Random | spread_amount_random | float | Random variation for spread amount |
| Spread Distance Random | spread_distance_random | float | Random variation for spread distance |
| Spread Angle Random | spread_angle_random | float | Random variation for spread angle |
## PCCStack2D
The `PCCStack2D` component generates a stack of projectiles.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Stack Amount | stack_amount | int | Number of projectiles in the stack |
| Stack Distance | stack_distance | float | Distance between projectiles |
| Stack Amount Random | stack_amount_random | float | Random variation for stack amount |
| Stack Distance Random | stack_distance_random | float | Random variation for stack distance |
---
[Back to Documentation Index](_sidebar.md)
