extends Node2D


@onready var button_1 : Button = %Button
@onready var button_2 : Button = %Button2
@onready var button_3 : Button = %Button3
@onready var button_4 : Button = %Button4

@onready var projectile_count : Label = %ProjectileCount
@onready var projectile_instance_count : Label = %ProjectileCount2
@onready var projectile_node_count : Label = %ProjectileCount3


func _ready() -> void:
	setup()
	pass

func setup() -> void:
	button_1.button_up.connect(ProjectileEngine.clear_projectile_instances)
	button_2.button_up.connect(ProjectileEngine.clear_projectile_nodes)
	button_3.button_up.connect(ProjectileEngine.clear_all_projectiles)
	button_4.button_up.connect(ProjectileEngine.refresh_projectile_engine)


func _physics_process(delta: float) -> void:
	projectile_count.text = str(ProjectileEngine.active_projectile_count)
	projectile_instance_count.text = str(ProjectileEngine.get_active_projectile_instance_count())
	projectile_node_count.text = str(ProjectileEngine.get_active_projectile_node_count())
