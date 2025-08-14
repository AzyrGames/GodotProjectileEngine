# ProjectileSpeedCurve
The `ProjectileSpeedCurve` behavior modifies projectile speed based on a Curve resource. It extends the `ProjectileBehaviorSpeed` class and provides the following properties:
-   **speed_modify_method**: How the curve value modifies the speed (add/multiply/override)
-   **speed_process_mode**: Scale process mode
-   **speed_curve_loop_method**: How the curve loops over time
-   **speed_curve_sample_method**: What value to use for sampling the curve (time/distance/etc)
-   **speed_curve**: Curve defining speed modification
---
[Back to Documentation Index](_sidebar.md)
