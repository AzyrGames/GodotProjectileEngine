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

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Accelerate | `speed_accelerate` | float | Acceleration rate in units/sec² |
| Speed Min | `speed_min` | float | Minimum speed limit |
| Speed Max | `speed_max` | float | Maximum speed limit |
## ProjectileSpeedClamp
Clamps the projectile's speed within a range.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Min | `speed_min` | float | Minimum speed limit |
| Speed Max | `speed_max` | float | Maximum speed limit |
## ProjectileSpeedCurve
Modifies speed based on a curve.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Curve | `curve` | Curve | Resource defining speed over time |
| Speed Curve Sample Method | `speed_curve_sample_method` | String | Sampling value (time/distance) |
| Speed Modify Method | `speed_modify_method` | String | How curve modifies speed (add/override) |
## ProjectileSpeedExpression
Modifies speed using mathematical expressions.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Expression Sample Method | `speed_expression_sample_method` | String | Value for expression variable |
| Speed Modify Method | `speed_modify_method` | String | How expression modifies speed |
| Expression Strength | `expression_strength` | float | Strength of expression effect |
| Speed Expression Variable | `speed_expression_variable` | String | Variable name (default 't') |
| Speed Expression | `speed_expression` | String | Mathematical expression (e.g., `100 * sin(t)`) |
## ProjectileSpeedModify
Modifies speed by a fixed value.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Modify Value | `speed_modify_value` | float | Value to modify speed |
| Speed Modify Method | `speed_modify_method` | String | Modification method (addition/override) |
## ProjectileSpeedSet
Sets speed to a specific value.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Speed Set Value | `speed_set_value` | float | Value to set speed to |
---
[Back to Documentation Index](_sidebar.md)
