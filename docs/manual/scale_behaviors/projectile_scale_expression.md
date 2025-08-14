# ProjectileScaleExpression
The `ProjectileScaleExpression` behavior modifies projectile scale using a mathematical expression. It extends the `ProjectileBehaviorScale` class and provides the following properties:
-   **scale_expression_sample_method**: What value to use for the expression variable (time/distance/etc)
-   **scale_modify_method**: How the expression result modifies scale (add/multiply/override)
-   **scale_process_mode**: Scale process mode
-   **scale_expression_variable**: Variable name to use in the expression (default 't')
-   **scale_expression**: Mathematical expression defining scale behavior e.g. [code]sin(t) * 2[/code]
---
[Back to Documentation Index](_sidebar.md)
