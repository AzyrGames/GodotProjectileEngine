# Scale Behaviors
## Components
- [ProjectileScaleAccelerate](#projectilescaleaccelerate)
- [ProjectileScaleCurve](#projectilescalecurve)
- [ProjectileScaleExpression](#projectilescaleexpression)
- [ProjectileScaleVectorAccelerate](#projectilescalevectoraccelerate)
- [ProjectileScaleModify](#projectilescalemodify)
- [ProjectileScaleVectorExpression](#projectilescalevectorexpression)
Scale behaviors modify the projectile's scale over time.
## ProjectileScaleAccelerate
Accelerates the projectile's scale.
## Properties
- **scale_accelerate**: Acceleration rate
- **scale_min**: Minimum scale
- **scale_max**: Maximum scale
## ProjectileScaleCurve
Modifies scale based on a curve.
## Properties
- **curve**: Curve resource defining scale over time
- **scale_curve_sample_method**: Value for sampling (time/distance)
- **scale_modify_method**: How curve modifies scale (add/override)
## ProjectileScaleExpression
Modifies scale using mathematical expressions.
## Properties
- **scale_expression_sample_method**: Value for expression variable
- **scale_modify_method**: How expression modifies scale
- **expression_streght**: Expression strength
- **scale_expression_variable**: Variable name (default 't')
- **scale_x_expression**: X-scale expression
- **scale_y_expression**: Y-scale expression
## ProjectileScaleVectorAccelerate
Accelerates scale in vector form.
## Properties
- **scale_vector_accelerate**: Vector acceleration
- **scale_min**: Minimum scale vector
- **scale_max**: Maximum scale vector
## ProjectileScaleModify
Modifies scale by a fixed value.
## Properties
- **scale_modify_value**: Value to modify scale
- **scale_modify_method**: Modification method (addition/override)
## ProjectileScaleVectorExpression
Modifies scale vector using expressions.
## Properties
- **scale_vector_expression_sample_method**: Value for expression variable
- **scale_vector_modify_method**: How expression modifies scale
- **expression_streght**: Expression strength
- **scale_vector_expression_variable**: Variable name (default 't')
- **scale_vector_x_expression**: X-scale expression
- **scale_vector_y_expression**: Y-scale expression
---
[Back to Documentation Index](_sidebar.md)
