# ProjectileDirectionExpression
The `ProjectileDirectionExpression` behavior modifies projectile direction using a mathematical expression. It extends the `ProjectileBehaviorDirection` class and provides the following properties:
-   **direction_expression_sample_method**: What value to use for the expression variable (time/distance/etc)
-   **direction_modify_method**: How the expression result modifies direction (add/multiply/override)
-   **expression_streght**: Expression strength
-   **direction_expression_variable**: Variable name to use in the expression (default 't')
-   **direction_x_expression**: Mathematical expression defining direction behavior for x e.g. `cos(t)`
-   **direction_y_expression**: Mathematical expression defining direction behavior for y e.g. `sin(t)`
---
[Back to Documentation Index](_sidebar.md)
