# Projectile Template
The Projectile Template is a core component of the Godot Projectile Engine, defining how bullets work and behave when spawned. It provides a base for creating various types of projectiles with different properties and behaviors.
## Projectile Updaters and Templates
The Godot Projectile Engine provides different types of Projectile Templates and corresponding Projectile Updaters to handle various projectile behaviors:
- **ProjectileTemplateSimple2D**: A simple projectile template with basic properties. It uses `ProjectileUpdaterSimple2D` to update the projectile's position and other properties.
- **ProjectileTemplateAdvanced2D**: An advanced projectile template with more complex properties and behaviors. It uses `ProjectileUpdaterAdvanced2D` to handle advanced projectile behaviors such as homing and bouncing.
- **ProjectileTemplateCustom2D**: A custom projectile template that allows for defining custom behaviors using ProjectileBehaviors. It uses `ProjectileUpdaterCustom2D` to update the projectile based on the defined behaviors.
- **ProjectileTemplateNode2D**: A projectile template that uses a separate scene to define the projectile's appearance and behavior. It uses `ProjectileNodeManager` to manage the projectile's node and its properties.
## ProjectileTemplateCustom and Projectile2D
ProjectileTemplateCustom and Projectile2D nodes utilize ProjectileBehaviors to define custom projectile behaviors. ProjectileBehaviors can be used to add various effects and functionalities to projectiles, such as:
- Movement patterns
- Collision effects
- Visual effects
- Sound effects
---
[Back to Documentation Index](_sidebar.md)
