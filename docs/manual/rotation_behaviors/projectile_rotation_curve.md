# ProjectileRotationCurve
The `ProjectileRotationCurve` behavior modifies projectile rotation based on a Curve resource. It extends the `ProjectileBehaviorRotation` class and provides the following properties:
-   **rotation_modify_method**: How the curve value modifies the rotation (add/multiply/override)
-   **rotation_process_mode**: How the curve loops over time
-   **rotation_curve_loop_method**: How the curve loops over time
-   **rotation_curve_sample_method**: What value to use for sampling the curve (time/distance/etc)
-   **rotation_curve**: Curve defining rotation modification over [param rotation_modify_method]
---
[Back to Documentation Index](_sidebar.md)
