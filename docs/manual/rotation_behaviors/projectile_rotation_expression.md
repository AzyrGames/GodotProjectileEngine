# ProjectileRotationExpression
The `ProjectileRotationExpression` behavior modifies projectile rotation using a mathematical expression. It extends the `ProjectileBehaviorRotation` class and provides the following properties:
-   **rotation_expression_sample_method**: What value to use for the expression variable (time/distance/etc)
-   **rotation_modify_method**: How the expression result modifies rotation (add/multiply/override)
-   **rotation_process_mode**: Rotation process mode
-   **rotation_expression_variable**: Variable name to use in the expression (default 't')
-   **rotation_expression**: Mathematical expression defining rotation behavior e.g. [code]sin(t) * 100[/code]
---
[Back to Documentation Index](_sidebar.md)
