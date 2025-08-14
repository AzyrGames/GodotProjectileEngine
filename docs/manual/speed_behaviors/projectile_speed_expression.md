# ProjectileSpeedExpression
The `ProjectileSpeedExpression` behavior modifies projectile speed using a mathematical expression. It extends the `ProjectileBehaviorSpeed` class and provides the following properties:
-   **speed_expression_sample_method**: What value to use for the expression variable (time/distance/etc)
-   **speed_modify_method**: How the expression result modifies speed (add/multiply/override)
-   **speed_process_mode**: Scale process mode
-   **speed_expression_variable**: Variable name to use in the expression (default 't')
-   **speed_expression**: Mathematical expression defining speed behavior e.g. [code]sin(t) * 100[/code]
---
[Back to Documentation Index](_sidebar.md)
