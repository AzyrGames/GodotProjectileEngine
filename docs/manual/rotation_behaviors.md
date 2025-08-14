# Rotation Behaviors
## Components
- [ProjectileRotationCurve](#projectilerotationcurve)
- [ProjectileRotationExpression](#projectilerotationexpression)
- [ProjectileRotationFollowDirection](#projectilerotationfollowdirection)
- [ProjectileRotationModify](#projectilerotationmodify)
- [ProjectileRotationSet](#projectilerotationset)
Rotation behaviors modify the projectile's rotation over time.
## ProjectileRotationCurve
Modifies rotation based on a curve.
## Properties
- **curve**: Curve resource defining rotation over time
- **rotation_curve_sample_method**: Value for sampling (time/distance)
- **rotation_modify_method**: How curve modifies rotation (add/override)
## ProjectileRotationExpression
Modifies rotation using mathematical expressions.
## Properties
- **rotation_expression_sample_method**: Value for expression variable
- **rotation_modify_method**: How expression modifies rotation
- **expression_streght**: Expression strength
- **rotation_expression_variable**: Variable name (default 't')
- **rotation_expression**: Mathematical expression (e.g., `sin(t)`)
## ProjectileRotationFollowDirection
Makes rotation follow projectile direction.
## ProjectileRotationModify
Modifies rotation by a fixed value.
## Properties
- **rotation_modify_value**: Value to modify rotation
- **rotation_modify_method**: Modification method (addition/override)
## ProjectileRotationSet
Sets rotation to a specific value.
## Properties
- **rotation_set_value**: Value to set rotation to
---
[Back to Documentation Index](_sidebar.md)
