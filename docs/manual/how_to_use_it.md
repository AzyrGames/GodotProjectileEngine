# How to use Godot Projectile Engine

This section will provide information on how to use the Godot Projectile Engine, from getting the addon and creating your first projectile to designing more intricate patterns.

## Getting Godot Projectile Engine

### Via Asset Library (Recommended)

1. Open **AssetLib** in Godot Editor
2. Search for `Godot Projectile Engine` by `AzyrGames`
3. Click **Download** → **Install**
4. **Enable** `GodotProjectileEngine` in `Project > Project Settings > Plugins`
5. **Restart editor**

### Manual Installation
1. Download [latest version](https://github.com/AzyrGames/GodotProjectileEngine/releases)
2. Extract the ZIP or tar.gz archive
3. Copy `/addons/godot_projectile_engine` folder
4. Paste into your project's `/addons` directory
5. Verify and **enable** `godot_projectile_engine` in `Project > Project Settings > Plugins`
6. **Restart editor**

## Your first Projectiles

Make sure the Godot Projectile Engine addon is installed and enabled.

1.  Create a new, empty Node2D scene.
2.  Add a **ProjectileEnvironment2D** Node2D: This is where projectiles will be placed, along with the manager node.
3.  Add a **ProjectileSpawner2D** Node2D: This node is where the projectile will be spawned.
    -   Leave this empty for now.
4.  Add a **PatternComposer2D** Node: This node processes and creates your projectile patterns.
    -   Set the `composer_name` to a unique string (in this case, we'll call it `simple_1`).
5.  Add a **TimingScheduler** Node: This node controls when a pattern is spawned.
    -   Add a **TSCRepeater** Node as a child: This node will repeat at a defined interval.
6.  Go back to the **ProjectileSpawner2D** node:
    -   Assign the `projectile_composer_name` to `simple_1`.
    -   In the `projectile_template_2d`, create a new **ProjectileTemplateSimple2D** resource.
    -   Under the **ProjectileTemplateSimple2D** resource, assign any texture you want. We'll use the default Godot `icon.svg` for this example.
    -   Assign the new `TimingScheduler` we just created to the `timing_scheduler` property.
7.  Add a new **Camera2D** Node2D for a better view.
8.  Save the current scene.
9.  Run the scene; if everything goes correctly, you will see your first projectiles.

## Your first Projectile Pattern

We will resuse the previous first Projectiles scene.

Create a new `PatternComposer2D` Node2D with different `projectile_composer_name`, which we'll call `pattern_1`. 

Remember to assign the correct composer name to your `ProjectileSpawner2D` node.

For your first projectile pattern, we will create a classic spinning bullet pattern:
-   Under your new **PatternComposer2D** node:
    1.  Create a new child `PCCSingle2D` Node.
        -   Set the `rotation_speed` to `17`.
        -   Set the `rotation_process_mode` to `Ticks`.
        -   This node will now rotate 17 degrees every time a new pattern is spawned (i.e., every tick).
    2.  Create a new child `PPCPolygon2D` Node.
        -   Set the `polygon_sides` to `7`.
-   Save the current scene.
-   Run the scene. If everything goes correctly, you will see your first spinning projectile pattern.
**Extra:**
- Change `duration` value in `TSCRepeater` node to lower value.
- Experiment with different `ProjectileTemplateSimple` Rerouces and `PatternComposer2D` nodes variable values to 
see how they interact with your pattern.

