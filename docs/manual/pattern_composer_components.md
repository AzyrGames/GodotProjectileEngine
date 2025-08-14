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
The `PCCCustomShape2D` component generates projectile positions based on a Curve2D resource. It provides the following properties:
-   **shape_path**: Curve2D resource defining the shape
-   **shape_sample_method**: Method used to sample points from the shape (POINTS, BAKED_POINTS, INSIDE_RANDOM, PERIMETER_RANDOM, PERIMETER_UNIFORM_DISTANCE)
-   **point_per_spawn**: Number of points to spawn per pattern composer data
-   **reset_per_spawn**: Reset the point index per spawn
-   **uniform_distance**: Distance between points for uniform sampling
## PCCGroup
The `PCCGroup` component groups other PatternComposerComponent nodes together. It extends the `PatternComposerComponent` class and processes each child component in sequence.
## PCCPolygon2D
The `PCCPolygon2D` component generates projectile positions in a polygon shape. It extends the `PatternComposerComponent` class and provides the following properties:
-   **radius**: Radius of the polygon
-   **polygon_sides**: Number of sides of the polygon
-   **spread_out**: If true, direction will rotate to match projectile's texture rotation
-   **radius_random**: Random variation for radius
-   **polygon_sides_random**: Random variation for polygon sides
## PCCLoop
The `PCCLoop` component loops through all child Pattern Composer Components a number of times. It extends the `PatternComposerComponent` class and provides the following properties:
-   **loop_count**: Number of times to loop through child components
## PCCShape2D
The `PCCShape2D` component generates projectile positions based on a Shape2D resource. It extends the `PatternComposerComponent` class and provides the following properties:
-   **shape_2d**: Shape2D resource defining the shape
-   **shape_sample_method**: Method used to sample points from the shape (INSIDE_RANDOM, PERIMETER_RANDOM)
## PCCSingle2D
The `PCCSingle2D` component sets the direction and rotation for each incoming PatternComposerData. It extends the `PatternComposerComponent` class and provides the following properties:
-   **direction_type**: Type of direction will be processed
-   **fixed_direction**: Normalized fixed direction
-   **target_group**: Target group name
-   **group_selection**: Group node selection method
-   **direction_rotation**: Direction Rotation as degrees
-   **rotation_speed**: Direction Rotation Speed as degrees
-   **target_groups**: Array of target group names
## PCCSpeedMod2D
The `PCCSpeedMod2D` component modifies the speed of projectiles. It extends the `PatternComposerComponent` class.
## PCCSpread2D
The `PCCSpread2D` component generates a spread of projectiles. It extends the `PatternComposerComponent` class and provides the following properties:
-   **spread_type**: Type of spread (STRAIGHT, ANGLE, HYBRID)
-   **spread_amount**: Number of projectiles in the spread
-   **spread_distance**: Distance between projectiles in the straight spread
-   **spread_angle**: Angle between projectiles in the angle spread
-   **spread_amount_random**: Random variation for spread amount
-   **spread_distance_random**: Random variation for spread distance
-   **spread_angle_random**: Random variation for spread angle
## PCCStack2D
The `PCCStack2D` component generates a stack of projectiles. It extends the `PatternComposerComponent` class and provides the following properties:
-   **stack_amount**: Number of projectiles in the stack
-   **stack_distance**: Distance between projectiles in the stack
-   **stack_amount_random**: Random variation for stack amount
-   **stack_distance_random**: Random variation for stack distance
---
[Back to Documentation Index](_sidebar.md)
