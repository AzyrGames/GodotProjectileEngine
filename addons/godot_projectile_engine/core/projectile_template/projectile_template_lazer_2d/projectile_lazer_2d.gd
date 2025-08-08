@icon("uid://b848vxv35dbv7")
extends Projectile2D
class_name ProjectileLazer2D

enum TEXTUREMODE {
	None, 
	Tile, 
	Stretch
	}

enum CAP {
	None, 
	Box, 
	Round
	}

enum LazerType {
	STRAIGHT,
	CURVY
}

@export_category("ProjectileLazer2D")

@export var lazer_type : LazerType = LazerType.STRAIGHT
@export var start_full_length : bool = true
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var lazer_length : float = 64.0:
	set(value):
		lazer_length = value
		update_lazer_line_2d()
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var lazer_width : float = 16.0:
	set(value):
		lazer_width = value
		update_lazer_line_2d()
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var collision_width : float = 16.0:
	set(value):
		collision_width = value
		update_lazer_line_2d()

@export_category("Texture")
@export var texture : Texture2D = null:
	set(value):
		texture = value
		update_lazer_line_2d()
@export var gradient : Gradient:
	set(value):
		gradient = value
		update_lazer_line_2d()
@export var texture_mode : Line2D.LineTextureMode = Line2D.LineTextureMode.LINE_TEXTURE_STRETCH:
	set(value):
		texture_mode = value
		update_lazer_line_2d()
@export var width_curve : Curve:
	set(value):
		width_curve = value
		update_lazer_line_2d()
@export var begin_cap_mode : Line2D.LineCapMode:
	set(value):
		begin_cap_mode = value
		update_lazer_line_2d()
@export var end_cap_mode : Line2D.LineCapMode:
	set(value):
		end_cap_mode = value
		update_lazer_line_2d()

var lazer_line_2d : Line2D

func _ready() -> void:
	super()
	setup_projectile_lazer()
	pass


func _physics_process(delta: float) -> void:
	super(delta)
	if start_full_length: return
	lazer_line_2d.clear_points()
	match lazer_type:
		LazerType.STRAIGHT:
			if life_distance < lazer_length:
				# velocity = Vector2.ZERO
				lazer_line_2d.add_point(lazer_line_2d.position - direction_final * life_distance)
				lazer_line_2d.add_point(lazer_line_2d.position)
				collision_shape.global_position = global_position - direction_final * life_distance / 2
				collision_shape.shape.size = Vector2(life_distance, collision_width)
				collision_shape.rotation = direction_rotation

			else:
				lazer_line_2d.add_point(lazer_line_2d.position - direction_final * lazer_length)
				lazer_line_2d.add_point(lazer_line_2d.position)
				collision_shape.global_position = global_position - direction_final * lazer_length / 2
				collision_shape.shape.size = Vector2(lazer_length, collision_width)
				collision_shape.rotation = direction_rotation
		_:
			pass
	# update_lazer_line_2d()
	pass


func update_lazer_line_2d() -> void:
	if !lazer_line_2d:
		return
	lazer_line_2d.texture = texture
	lazer_line_2d.texture_mode = texture_mode
	lazer_line_2d.width_curve = width_curve
	lazer_line_2d.joint_mode = Line2D.LINE_JOINT_ROUND
	lazer_line_2d.begin_cap_mode = begin_cap_mode
	lazer_line_2d.end_cap_mode = end_cap_mode
	lazer_line_2d.width = lazer_width
	lazer_line_2d.clear_points()
	match lazer_type:
		LazerType.STRAIGHT:
			lazer_line_2d.add_point(lazer_line_2d.position)
			lazer_line_2d.add_point(lazer_line_2d.position + direction_final * lazer_length)
		_:
			pass
	collision_shape.global_position = global_position + direction_final * lazer_length / 2
	collision_shape.shape.size = Vector2(lazer_length, collision_width)
	collision_shape.rotation = direction_rotation

	pass

func setup_projectile_lazer() -> void:
	lazer_line_2d = Line2D.new()
	lazer_line_2d.texture = texture
	lazer_line_2d.texture_mode = texture_mode
	lazer_line_2d.width_curve = width_curve
	lazer_line_2d.joint_mode = Line2D.LINE_JOINT_ROUND
	lazer_line_2d.begin_cap_mode = begin_cap_mode
	lazer_line_2d.end_cap_mode = end_cap_mode
	lazer_line_2d.width = lazer_width
	lazer_line_2d.owner = owner
	add_child(lazer_line_2d, true)
	lazer_line_2d.clear_points()
	match lazer_type:
		LazerType.STRAIGHT:
			collision_shape = CollisionShape2D.new()
			var _rect_shape = RectangleShape2D.new()
			collision_shape.shape = _rect_shape
			# lazer_line_2d.add_point(lazer_line_2d.position)
			if start_full_length:
				lazer_line_2d.add_point(lazer_line_2d.position + direction.rotated(direction_rotation) * lazer_length)
				collision_shape.global_position = direction.rotated(direction_rotation) * lazer_length / 2
				# collision_shape.shape.size = Vector2(lazer_length, collision_width)
				collision_shape.rotation = direction_rotation
			else:
				# collision_shape.global_position = 
				collision_shape.shape.size = Vector2(1, collision_width)

		_:
			pass
	


	add_child(collision_shape)
	# collision_shape.shape.
	pass
