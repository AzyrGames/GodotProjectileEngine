# Direction Behaviors

[ProjectileBehaviorDirection](manual/direction_behaviors.md) is a [Projectile Behavior](manual/projectile_behaviors_overview.md) that modify the projectile's direction.

## Components
- [ProjectileDirectionCurve2D](#projectiledirectioncurve2d)
- [ProjectileDirectionExpression](#projectiledirectionexpression)
- [ProjectileDirectionFollowRotation](#projectiledirectionfollowrotation)
- [ProjectileDirectionModify](#projectiledirectionmodify)
- [ProjectileDirectionRandomWalk](#projectiledirectionrandomwalk)

## Properties
### DirectionModifyMethod
```GDScrip
enum DirectionModifyMethod{
	ROTATION,
	ADDITION,
	OVERRIDE,
}
```

## ProjectileDirectionCurve2D
Modifies direction based on a Curve2D resource.
### Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Curve 2D | `curve_2d` | Curve2D | Resource defining the path |
| Curve Strength | `curve_strength` | float | Strength of the curve effect |
| Direction Curve Sample Method | `direction_curve_sample_method` | String | Value to use for sampling (time/distance) |
| Direction Modify Method | `direction_modify_method` | [DirectionModifyMethod](#DirectionModifyMethod) | How curve modifies direction (add/override) |
## ProjectileDirectionExpression
Modifies direction using mathematical expressions.
### Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Direction Expression Sample Method | `direction_expression_sample_method` | String | Value for expression variable |
| Direction Modify Method | `direction_modify_method` | [DirectionModifyMethod](#DirectionModifyMethod) | How expression modifies direction |
| Expression Strength | `expression_streght` | float | Strength of the expression effect |
| Direction Expression Variable | `direction_expression_variable` | String | Variable name (default 't') |
| Direction X Expression | `direction_x_expression` | String | X-direction expression (e.g., `cos(t)`) |
| Direction Y Expression | `direction_y_expression` | String | Y-direction expression (e.g., `sin(t)`) |
## ProjectileDirectionFollowRotation
Makes direction follow projectile rotation.
## ProjectileDirectionModify
Modifies direction by a value.
### Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Direction Modify Value | `direction_modify_value` | float | Value to modify direction |
| Direction Modify Method | `direction_modify_method` | [DirectionModifyMethod](#DirectionModifyMethod) | Modification method (rotation/addition/override) |
## ProjectileDirectionRandomWalk
Modifies direction with random noise.
### Properties

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Noise Strength | `noise_strength` | float | Strength of noise |
| Noise Frequency | `noise_frequency` | float | Noise frequency |
| Noise Seed | `noise_seed` | int | Seed for noise generation |
| Direction Modify Method | `direction_modify_method` | [DirectionModifyMethod](#DirectionModifyMethod) | How noise modifies direction |
---
[Back to Documentation Index](_sidebar.md)
