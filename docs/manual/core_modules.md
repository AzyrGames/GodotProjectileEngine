# Core Modules Overview
The Godot Projectile Engine's core is structured into several modules, each responsible for a specific aspect of projectile management.
## Pattern Composer
The `pattern_composer` module is responsible for composing patterns of projectiles. It uses the `PatternComposer2D` node, defined in `pattern_composer.gd`, to process requests and generate projectile patterns based on `PatternComposerComponent` nodes.
## Projectile Environment
The `projectile_environment` module manages the environment in which projectiles exist. The `ProjectileEnvironment2D` node, defined in `projectile_environment.gd`, handles projectile collisions and provides access to a `ProjectileBouncingHelper`.
## Projectile Spawner
The `projectile_spawner` module is responsible for spawning projectiles. The `ProjectileSpawner2D` node, defined in `projectile_spawner.gd`, uses a `PatternComposer2D` to determine the projectile pattern, a `ProjectileTemplate2D` to define the projectile's properties, and a `TimingScheduler` to control when projectiles are spawned.
## Projectile Template
The `projectile_template` module provides templates for different types of projectiles. The `ProjectileTemplate2D` resource, defined in `projectile_template_2d.gd`, stores custom data for projectiles.
## Projectile Wrapper
The `projectile_wrapper` module wraps projectiles with additional functionality. The `ProjectileWrapper2D` node, defined in `projectile_wrapper_2d.gd`, wraps a `ProjectileSpawner2D` and allows for enabling/disabling the spawner.
## Timing Scheduler
The `timing_scheduler` module handles the timing and scheduling of events. The `TimingScheduler` node, defined in `timing_scheduler.gd`, manages the timing and scheduling of events using `TimingSchedulerComponent` nodes.
---
[Back to Documentation Index](_sidebar.md)
