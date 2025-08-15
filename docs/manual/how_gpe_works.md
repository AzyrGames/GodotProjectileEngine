# How Godot Projectile Engine Works

This section will provide information on how the Godot Projectile Engine works at both a high and low level. Understanding these concepts will help you use the add-on more easily.

## High-Level

The Godot Projectile Engine uses **ProjectileTemplate2D** to determine what projectile to spawn, whether it's a **ProjectileInstance2D** or a **ProjectileNode2D**. When the **TimingScheduler** is timed, the **PatternComposer** will process and provide data to the **ProjectileSpawner2D**, which will then call a corresponding **ProjectileUpdater2D** or **ProjectileNodeManager2D** in the **ProjectileEnvironment2D** to instantiate new projectiles to the scene.

The **ProjectileSpawner2D** acts as the manager that holds references to the **ProjectileTemplate2D**, **PatternComposer**, and **TimingScheduler**.

The **ProjectileEnvironment2D** is the parent node for the **ProjectileUpdater2D** or **ProjectileNodeManager2D**, which is where the projectiles are

The **PatternComposer** will use the **ProjectileSpawner2D**'s position to define where projectiles will spawn. A **ProjectileSpawner2D** can also have multiple **ProjectileSpawnerMarker2D**s.

### **Reference Chart**

```mermaid
graph TD
    %% Central Manager
    PS[ProjectileSpawner2D]
    
    %% Referenced Components
    TS[TimingScheduler]
    PT[ProjectileTemplate2D]
    PC[PatternComposer]
    
    %% Spawn Markers
    PSM1[ProjectileSpawnerMarker2D]
    
    %% Environment and Managers
    PE[ProjectileEnvironment2D]
    PU[ProjectileUpdater2D]
    PNM[ProjectileNodeManager2D]
    
    %% Projectile Types
    PI[ProjectileInstance2D]
    PN[ProjectileNode2D]
    
    %% Reference Relationships
    PS -.->|references| TS
    PS -.->|references| PT
    PS -.->|references| PC
    PS -->|has multiple| PSM1
    
    %% Parent-Child Relationships
    PE -->|parent of| PU
    PE -->|parent of| PNM
    
    %% Type Determination
    PT -.->|determines type| PU
    PT -.->|determines type| PNM
    
    %% Spawning Relationships
    PU -->|spawns| PI
    PNM -->|spawns| PN
    
    %% Position Usage
    PC -->|uses positions| PSM1
    
    %% Color scheme with Primary #F7784B and complementary colors
    classDef core fill:#E3F2FD,stroke:#1976D2,stroke-width:3px,color:#0D47A1
    classDef manager fill:#F7784B,stroke:#D84315,stroke-width:2px,color:#FFFFFF
    classDef projectile fill:#E8F5E8,stroke:#388E3C,stroke-width:2px,color:#1B5E20
    classDef environment fill:#FFF3E0,stroke:#F57C00,stroke-width:2px,color:#E65100
    
    class PS core
    class TS,PT,PC core
    class PU,PNM manager
    class PI,PN projectile
    class PE,PSM1,PSM2,PSM3 environment
```
### **Logic Chart**
```mermaid
%%{init: {'theme':'base', 'themeVariables': { 'primaryColor': '#E3F2FD', 'primaryTextColor': '#0D47A1', 'primaryBorderColor': '#1976D2', 'lineColor': '#F7784B', 'secondaryColor': '#F7784B', 'tertiaryColor': '#E8F5E8', 'background': '#FFF3E0', 'mainBkg': '#E3F2FD', 'secondBkg': '#F7784B', 'tertiaryBkg': '#E8F5E8', 'activationBkgColor': '#F7784B', 'activationBorderColor': '#D84315', 'noteTextColor': '#1B5E20', 'noteBkgColor': '#E8F5E8', 'noteBorderColor': '#388E3C', 'altSectionBkgColor': '#FFF3E0'}}}%%
sequenceDiagram
    participant TS as TimingScheduler
    participant PS as ProjectileSpawner2D
    participant PC as PatternComposer
    participant PE as ProjectileEnvironment2D
    participant Manager as Updater/NodeManager
    participant Projectile as Instance/Node
    
    TS->>PS: Timed
    PS->>PC: Request Pattern
    Note over PC: Uses spawner/markers position
    PC-->>PS: Pattern Data Pack
    PS->>PE: Request Spawn
    PE->>Manager: Spawn Projectiles
    
    alt ProjectileInstance2D
        Manager->>Projectile: Active Projectile Instance
    else ProjectileNode2D
        Manager->>Projectile: Active/Instantiate Projectile Node
    end
    
    Manager->>PE: Add to scene
    Note over PE: Projectile spawned and ready
```

## Low-level

(*Documentation in progress*)