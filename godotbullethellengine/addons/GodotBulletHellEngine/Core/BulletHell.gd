extends Node



signal bullet_trigger_activated(bullet_instance: BulletInstance2D)

var active_bullet_count : int

var bullet_template_2d_nodes : Dictionary[RID, BulletTemplate2D]

var bullet_updater_2d_nodes : Dictionary[RID, BulletUpdater2D]

var bullet_environment : BulletEnvironment2D
# var 

var bullet_homing_targets : Dictionary[String, Array]

var bullet_composer_nodes : Dictionary[String, BulletComposer2D]