# Godot Projectile Engine
[![Godot 4.x](https://img.shields.io/badge/Godot-4.x-%23478cbf)](https://godotengine.org)
[![Status: Alpha](https://img.shields.io/badge/Status-Alpha-orange)](https://github.com/AzyrGames/GodotProjectileEngine)

**High-performance projectile system for Godot Engine** - Create and manage massive amounts of projectiles with optimal efficiency.

> [!WARNING]  
> **Alpha Notice (v0.5.1)**  
> This version contains frequent breaking changes and is not recommended for production use.

## Features
### 🧩 Modular Architecture
- **Separated components** for specialized functionality:
  - `ProjectileTemplate` - Define projectile properties
  - `ProjectileSpawner` - Handle projectile instantiation
  - `PatternComposer` - Design complex projectile/bullet patterns
  - `TimingScheduler` - Control firing sequences
- Components can be used for a different purpose.

### 🚀 Performance Optimized
- **Object pooling** for efficient resource management
- **Customizable ProjectileBehaviors** - Only use what you need
- **Minimal overhead** through optimized architecture

### 💡 Feature-Rich System
- Multiple projectile types with customizable behaviors
- Diverse pattern composers for varied projectile/bullet compositions
- Flexible timing scheduler for complex sequences

### 🛠️ User-Friendly Workflow
- Native Godot SceneTree integration
- Resource-based configuration
- Intuitive node editing

## Installation

### Via Asset Library (Recommended)
1. Open **AssetLib** in Godot Editor
2. Search for `Godot Projectile Engine` by `AzyrGames`
3. Click **Download** → **Install**
4. Enable `godot_projectile_engine` in `Project > Project Settings > Plugins`
5. **Restart editor**

### Manual Installation
1. Download [latest version](https://github.com/AzyrGames/GodotProjectileEngine/releases/tag/v0.5.1-alpha)
2. Extract the ZIP or tar.gz archive
3. Copy `/addons/godot_projectile_engine` folder
4. Paste into your project's `/addons` directory
5. Verify and enable `godot_projectile_engine` in `Project > Project Settings > Plugins`
6. **Restart editor**

## Quick Start
Create a basic projectile system in 5 steps:

1. **Create Scene**  
   Start with an empty `Node2D` root

2. **Add Environment**  
   Add a `ProjectileEnvironment2D` node

3. **Configure Pattern**  
   Add `PatternComposer2D`:
   - Set pattern name to `"simple_1"`

4. **Setup Timing**  
   Add `TimingScheduler` with child `TSCRepeater`

5. **Create Spawner**  
   Add `ProjectileSpawner2D`:
   - Set `projectile_composer_name` to `"simple_1"`
   - Create `ProjectileTemplateSimple2D` resource and assign a texture
   - Connect to `TimingScheduler`

6. **Optional**: Add `Camera2D` for better viewing

**Test**: Run the scene to see projectiles in action!
**Explore**: See advanced examples in `addons/godot_projectile_engine/examples/`


## Documentation
*Work in Progress*  

## Credits
*Contributors will be listed here*
