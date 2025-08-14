# Timing Scheduler Components
Timing Scheduler Components are nodes that define specific timing behaviors. They are used by the TimingScheduler node to create complex timing sequences for spawning projectiles.
The `TimingSchedulerComponent` class is the base class for all timing scheduler components. It provides core functionality and an interface that all component implementations must follow.
The TimingSchedulerComponent has the following properties:
-   **active**: Whether this component is currently active
-   **update_mode**: Timing update mode (IDLE, PHYSICS, or INHERIT)
## TSCCooldown
The `TSCCooldown` component waits for a fixed duration before completing. It extends the `TimingSchedulerComponent` class and provides the following properties:
-   **cooldown_duration**: Duration of the cooldown in seconds
## TSCRepeater
The `TSCRepeater` component repeats a duration multiple times. It extends the `TimingSchedulerComponent` class and provides the following properties:
-   **duration**: Duration to repeat in seconds
-   **repeat_count**: Repetition count (0=immediate, <0 infinite, >0 finite)
## TSCTimingSet
The `TSCTimingSet` component manages complex timing patterns using a TimingSet resource. It extends the `TimingSchedulerComponent` class and provides the following properties:
-   **timing_set**: TimingSet Resource containing timing intervals and playback parameters for sequenced or randomized execution.
---
[Back to Documentation Index](_sidebar.md)
