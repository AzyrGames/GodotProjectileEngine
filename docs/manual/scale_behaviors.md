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

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Scale Accelerate | `scale_accelerate` | float | Acceleration rate |
| Scale Min | `scale_min` | Vector2 | Minimum scale |
| Scale Max | `scale_max` | Vector2 | Maximum scale |
## ProjectileScaleCurve
Modifies scale based on a curve.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Curve | `curve` | Curve | Resource defining scale over time |
| Scale Curve Sample Method | `scale_curve_sample_method` | String | Value for sampling (time/distance) |
| Scale Modify Method | `scale_modify_method` | String | How curve modifies scale (add/override) |
## ProjectileScaleExpression
Modifies scale using mathematical expressions.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Scale Expression Sample Method | `scale_expression_sample_method` | String | Value for expression variable |
| Scale Modify Method | `scale_modify_method` | String | How expression modifies scale |
| Expression Strength | `expression_strength` | float | Strength of the expression effect |
| Scale Expression Variable | `scale_expression_variable` | String | Variable name (default 't') |
| Scale X Expression | `scale_x_expression` | String | X-scale expression |
| Scale Y Expression | `scale_y_expression` | String | Y-scale expression |
## ProjectileScaleVectorAccelerate
Accelerates scale in vector form.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Scale Vector Accelerate | `scale_vector_accelerate` | Vector2 | Vector acceleration |
| Scale Min | `scale_min` | Vector2 | Minimum scale vector |
| Scale Max | `scale_max` | Vector2 | Maximum scale vector |
## ProjectileScaleModify
Modifies scale by a fixed value.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Scale Modify Value | `scale_modify_value` | Vector2 | Value to modify scale |
| Scale Modify Method | `scale_modify_method` | String | Modification method (addition/override) |
## ProjectileScaleVectorExpression
Modifies scale vector using expressions.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Scale Vector Expression Sample Method | `scale_vector_expression_sample_method` | String | Value for expression variable |
| Scale Vector Modify Method | `scale_vector_modify_method` | String | How expression modifies scale |
| Expression Strength | `expression_strength` | float | Strength of the expression effect |
| Scale Vector Expression Variable | `scale_vector_expression_variable` | String | Variable name (default 't') |
| Scale Vector X Expression | `scale_vector_x_expression` | String | X-scale expression |
| Scale Vector Y Expression | `scale_vector_y_expression` | String | Y-scale expression |
---
[Back to Documentation Index](_sidebar.md)
