# ProjectileScaleVectorExpression
The `ProjectileScaleVectorExpression` behavior modifies projectile scale using separate mathematical expressions for x and y components. It extends the `ProjectileBehaviorScale` class and provides the following properties:
-   **scale_expression_sample_method**: What value to use for the expression variable (time/distance/etc)
-   **scale_expression_variable**: Variable name to use in the expression (default 't')
-   **scale_modify_method_x**: How the x expression result modifies scale (add/multiply/override)
-   **scale_process_mode_x**: Scale process mode for x
-   **scale_expression_x**: Mathematical expression defining x scale behavior e.g. [code]sin(t) * 2[/code]
-   **scale_modify_method_y**: How the y expression result modifies scale (add/multiply/override)
-   **scale_process_mode_y**: Scale process mode for y
-   **scale_expression_y**: Mathematical expression defining y scale behavior e.g. [code]cos(t) * 2[/code]
---
[Back to Documentation Index](_sidebar.md)
