# ProjectileNodeManager2D

Manages pooling and lifecycle of [ProjectileNode2D](/manual/projectile_template_node_2d.md) node instances.

## Properties
| Name | Variable Name | Type | Description |
|------|---------------|------|-------------|
| Projectile Template | `projectile_template_2d` | `ProjectileTemplate2D` | Associated template configuration |
| Node Array | `projectile_node_array` | `Array[Projectile2D]` | Pooled node instances |
| Active Nodes | `active_nodes` | `Array[Projectile2D]` | Currently active projectiles |
| Max Pooling | `projectile_pooling_amount` | `int` | Maximum pooled instances |

## Key Methods
- `setup_projectile_manager()` - Initializes pooling system from template
- `create_projectile_pool()` - Creates instance pool from packed scene
- `spawn_projectile_pattern()` - Activates instances based on pattern data
- `clear_projectiles()` - Deactivates/removes all active projectiles
- `get_active_projectile_count()` - Returns number of active instances
