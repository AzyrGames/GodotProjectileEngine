# Speed Behaviors
## Components
- [ProjectileSpeedAccelerate](#projectilespeedaccelerate)
- [ProjectileSpeedClamp](#projectilespeedclamp)
- [ProjectileSpeedCurve](#projectilespeedcurve)
- [ProjectileSpeedExpression](#projectilespeedexpression)
- [ProjectileSpeedModify](#projectilespeedmodify)
- [ProjectileSpeedSet](#projectilespeedset)
Speed behaviors modify the projectile's speed over time.
## ProjectileSpeedAccelerate
Accelerates the projectile's speed.
## Properties
- **speed_accelerate**: Acceleration rate
- **speed_min**: Minimum speed
- **speed_max**: Maximum speed
## ProjectileSpeedClamp
Clamps the projectile's speed within a range.
## Properties
- **speed_min**: Minimum speed
- **speed_max**: Maximum speed
## ProjectileSpeedCurve
Modifies speed based on a curve.
## Properties
- **curve**: Curve resource defining speed over time
- **speed_curve_sample_method**: Value for sampling (time/distance)
- **speed_modify_method**: How curve modifies speed (add/override)
## ProjectileSpeedExpression
Modifies speed using mathematical expressions.
## Properties
- **speed_expression_sample_method**: Value for expression variable
- **speed_modify_method**: How expression modifies speed
- **expression_streght**: Expression strength
- **speed_expression_variable**: Variable name (default 't')
- **speed_expression**: Mathematical expression (e.g., `100 * sin(t)`)
## ProjectileSpeedModify
Modifies speed by a fixed value.
## Properties
- **speed_modify_value**: Value to modify speed
- **speed_modify_method**: Modification method (addition/override)
## ProjectileSpeedSet
Sets speed to a specific value.
## Properties
- **speed_set_value**: Value to set speed to
---
[Back to Documentation Index](_sidebar.md)
