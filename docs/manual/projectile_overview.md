# Projectile Overview
The Godot Projectile Engine provides a comprehensive system for creating and managing various types of projectiles. This overview explains the core components and their relationships.

## Core Components

### 1. Projectile Templates ([ProjectileTemplate2D](projectile_template.md))
Define blueprint resources for projectile properties and behaviors:
- **Simple** - Basic straight-line projectiles
- **Advanced** - Projectiles with acceleration, homing, and triggers  
- **Custom** - Fully customizable via [Projectile Behaviors](projectile_behaviors_overview.md)
- **Node** - Projectiles defined by scene instances

Templates handle:
- Visual properties (textures, scale, rotation)
- Physics settings (collision shapes, layers)
- Behavior configurations
- Object pooling settings

### 2. Projectile Instances ([ProjectileInstance2D](projectile_instance.md))
Runtime objects created from templates:
- **Simple** - Basic movement and collision
- **Advanced** - Complex movement patterns and triggers
- **Custom** - Behavior-driven functionality

Manage:
- Current position/velocity
- Lifetime tracking
- Behavior state
- Custom data storage

### 3. Projectile Updaters ([ProjectileUpdater2D](projectile_updater.md))
Handle physics processing and rendering:
- **Simple** - Basic movement and lifecycle
- **Advanced** - Complex physics and homing
- **Custom** - Behavior system integration

Responsibilities:
- Position updates
- Collision detection
- Behavior execution
- Texture rendering
- Pool management

### 4. Projectile Nodes ([ProjectileNode2D](projectile_node_2d.md))
Scene-based projectiles with:
- Visual components
- Collision shapes  
- Behavior arrays
- Real-time editing

### 5. Projectile Manager ([ProjectileNodeManager2D](projectile_node_manager.md))
Manages projectile lifecycle:
- Object pooling
- Instance activation/deactivation
- Pattern spawning
- Performance optimization

## Workflow Overview
1. **Creation**: Manager instantiates projectiles from templates
2. **Initialization**: Configure properties from template data
3. **Update**: Updater processes physics and behaviors each frame
4. **Collision**: System detects and handles impacts
5. **Recycling**: Manager returns expired projectiles to pool

## Key Concepts
- **Object Pooling**: Reuses projectile instances for performance
- **Behavior System**: Modular components modify projectile properties
- **Template Inheritance**: Shared properties across projectile types
- **Double Dispatch**: Efficient collision handling through physics server

[Back to Documentation Index](_sidebar.md)
