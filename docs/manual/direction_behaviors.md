# Direction Behaviors
## Components
- [ProjectileDirectionCurve2D](#projectiledirectioncurve2d)
- [ProjectileDirectionExpression](#projectiledirectionexpression)
- [ProjectileDirectionFollowRotation](#projectiledirectionfollowrotation)
- [ProjectileDirectionModify](#projectiledirectionmodify)
- [ProjectileDirectionRandomWalk](#projectiledirectionrandomwalk)
Direction behaviors modify the projectile's direction over time.
## ProjectileDirectionCurve2D
Modifies direction based on a Curve2D resource.
## Properties
- **curve_2d**: Curve2D resource defining the path
- **curve_strenght**: Strength of the curve effect
- **direction_curve_sample_method**: Value to use for sampling (time/distance)
- **direction_modify_method**: How curve modifies direction (add/override)
## ProjectileDirectionExpression
Modifies direction using mathematical expressions.
## Properties
- **direction_expression_sample_method**: Value for expression variable
- **direction_modify_method**: How expression modifies direction
- **expression_streght**: Expression strength
- **direction_expression_variable**: Variable name (default 't')
- **direction_x_expression**: X-direction expression (e.g., `cos(t)`)
- **direction_y_expression**: Y-direction expression (e.g., `sin(t)`)
## ProjectileDirectionFollowRotation
Makes direction follow projectile rotation.
## ProjectileDirectionModify
Modifies direction by a fixed value.
## Properties
- **direction_modify_value**: Value to modify direction
- **direction_modify_method**: Modification method (rotation/addition/override)
## ProjectileDirectionRandomWalk
Modifies direction with random noise.
## Properties
- **noise_strength**: Strength of noise
- **noise_frequency**: Noise frequency
- **noise_seed**: Seed for noise generation
- **direction_modify_method**: How noise modifies direction
---
[Back to Documentation Index](_sidebar.md)
