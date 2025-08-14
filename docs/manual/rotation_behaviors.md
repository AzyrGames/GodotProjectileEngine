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

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Curve | `curve` | Curve | Resource defining rotation over time |
| Rotation Curve Sample Method | `rotation_curve_sample_method` | String | Value for sampling (time/distance) |
| Rotation Modify Method | `rotation_modify_method` | String | How curve modifies rotation (add/override) |
## ProjectileRotationExpression
Modifies rotation using mathematical expressions.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Rotation Expression Sample Method | `rotation_expression_sample_method` | String | Value for expression variable |
| Rotation Modify Method | `rotation_modify_method` | String | How expression modifies rotation |
| Expression Strength | `expression_strength` | float | Strength of the expression effect |
| Rotation Expression Variable | `rotation_expression_variable` | String | Variable name (default 't') |
| Rotation Expression | `rotation_expression` | String | Mathematical expression (e.g., `sin(t)`) |
## ProjectileRotationFollowDirection
Makes rotation follow projectile direction.
## ProjectileRotationModify
Modifies rotation by a fixed value.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Rotation Modify Value | `rotation_modify_value` | float | Value to modify rotation |
| Rotation Modify Method | `rotation_modify_method` | String | Modification method (addition/override) |
## ProjectileRotationSet
Sets rotation to a specific value.
## Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Rotation Set Value | `rotation_set_value` | float | Value to set rotation to |
---
[Back to Documentation Index](_sidebar.md)
