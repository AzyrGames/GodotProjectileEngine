# TimingSchedulerComponent
The base class for all timing scheduler components. These components define specific timing behaviors that are processed by the TimingScheduler node to create complex timing patterns.

## Component Properties
| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Active | `active` | bool | Whether component is currently active |
| Update Mode | `update_mode` | String | Timing update mode (IDLE/PHYSICS/INHERIT) |

## Components
### TSCCooldown
Waits for a fixed duration before completing.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Cooldown Duration | `cooldown_duration` | float | Duration in seconds |

### TSCRepeater
Repeats a duration multiple times.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Duration | `duration` | float | Repeat interval in seconds |
| Repeat Count | `repeat_count` | int | Number of repetitions (0=immediate, <0 infinite, >0 finite) |

### TSCTimingSet
Manages complex timing patterns using a TimingSet resource.

| Name | Variable Name | Variable Types | Descriptions |
|------|---------------|----------------|--------------|
| Timing Set | `timing_set` | TimingSet | Resource containing timing intervals and playback parameters |

[Back to Timing Scheduler](timing_scheduler_overview.md)
---
[Back to Documentation Index](_sidebar.md)
