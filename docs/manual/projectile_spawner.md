# Projectile Spawner

The ProjectileSpawner2D node coordinates projectile pattern spawning with timing and positioning control.

## Key Features
- Timed projectile pattern spawning via [TimingScheduler](timing_scheduler.md)
- Multiple spawn position support using [ProjectileSpawnMarker2D](manual/spawn_marker.md)
- Automatic projectile initialization
- Audio integration for spawn events
- Supports all projectile template types

## ProjectileSpawner2D

Core spawner node with these key properties:

| Property | Type | Description |
|----------|------|-------------|
| Active | bool | Whether spawner is currently active |
| Projectile Composer | String | Name of PatternComposer2D to use |
| Projectile Template | ProjectileTemplate2D | Template resource to spawn |
| Timing Scheduler | TimingScheduler | Timing configuration |
| Use Spawn Markers | bool | Enable marker-based spawning |
| Audio Stream | AudioStreamPlayer | Sound to play on spawn |


## Spawn Markers
Multiple independence [ProjectileSpawnMarker2D](manual/spawn_marker.md) can be added to Projectile Spawner Node to define:
- Spawn positions
- Initial rotations
- Custom spawn parameters


## Workflow
1. Spawner initializes projectile system based on template type
2. Connects to TimingScheduler events
3. On trigger, requests pattern from PatternComposer
4. Spawns projectiles using:
   - ProjectileUpdater for resource-based templates
   - ProjectileNodeManager for scene-based templates
5. Manages audio playback per spawn event


[Back to Projectile Overview](projectile_overview.md)
