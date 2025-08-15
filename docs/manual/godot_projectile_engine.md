# Godot Projectile Engine

A comprehensive 2D projectile system for Godot 4 that provides flexible, performance-oriented projectile management through modular components and behavior-driven design.

![Engine Architecture Diagram](media/engine_architecture.svg)

## Core Concepts

### 1. Projectile Components
- **[Templates](manual/projectile_template.md)** - Blueprint resources defining projectile properties
- **[Instances](manual/projectile_instance.md)** - Runtime projectile objects
- **[Updaters](manual/projectile_updater.md)** - Physics and rendering controllers  
- **[Nodes](manual/projectile_node_2d.md)** - Scene-based projectile implementations
- **[Manager](manual/projectile_node_manager.md)** - Lifecycle and pooling system

### 2. Behavior System
- Modular [Behaviors](manual/projectile_behaviors_overview.md) for dynamic projectile modification
- 8 behavior categories including Speed, Direction, and Destruction
- Customizable through GDScript or visual editing

### 3. Spawning System
- **[Spawners](manual/projectile_spawner.md)** with timing control
- Pattern composition via **[Pattern Composer](manual/pattern_composer.md)**
- Marker-based position control

## Key Features

### Core Systems
- Object pooling for high-performance instantiation
- Physics-aware collision handling
- Customizable through resources and scripts
- Multiple projectile types (Simple/Advanced/Custom)
- Laser and special projectile support

### Advanced Functionality
- Homing missile mechanics
- Curved trajectory support
- Damage system integration
- Audio/Visual effect triggers
- Complex pattern generation

## Workflow Overview

1. **Design** - Create Template resources and Behaviors
2. **Configure** - Set up Spawners with Timing schedules 
3. **Compose** - Build patterns using Composer components
4. **Manage** - Handle pooling and recycling through Managers
5. **Iterate** - Modify Behaviors and Templates in real-time

## Integration Points

```gdscript
# Basic setup example
var spawner = ProjectileSpawner2D.new()
spawner.projectile_template = preload("res://plasma.tres")
spawner.timing_scheduler = preload("res://burst_fire.tres")
add_child(spawner)
spawner.activate()
```

## Documentation Structure

- **[Projectile Overview](manual/projectile_overview.md)** - Core component relationships
- **[Behaviors](manual/projectile_behaviors_overview.md)** - Over 35 configurable behaviors
- **[Pattern Design](manual/pattern_composer.md)** - Creating complex firing patterns
- **[Optimization](manual/projectile_node_manager.md)** - Pooling and performance
- **[API Reference](api.md)** - Full class documentation

[Get Started with Simple Projectiles](manual/projectile_template.md#projectiletemplatesimple2d) | 
[View Example Projects](https://github.com/AzyrGames/GodotBulletHellEngine/tree/main/showcases)
