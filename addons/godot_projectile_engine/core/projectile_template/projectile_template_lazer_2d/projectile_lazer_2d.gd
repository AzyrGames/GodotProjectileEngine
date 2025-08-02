extends Projectile2D
class_name ProjectileLazer2D

const F32_MAX: float = 3.40282347e+38
## Minimum negative value of 32-bit float.
const F32_N_MIN: float = -3.40282347e+38

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

@export_category("ProjectileLazer2D")

@export_custom(PROPERTY_HINT_NONE, "suffix:px") var lazer_length : float = 64.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px")var lazer_width : float = 16.0

@export_category("Line2D")
@export var texture : Texture2D = null
@export var texture_mode : Line2D.LineTextureMode
@export var width_curve : Curve
@export var begin_cap_mode : Line2D.LineCapMode
@export var projectile_lazer_line_2d : Line2D


func _ready() -> void:
	super()
	setup_projectile_lazer_line_2d
	pass


func _physics_process(delta: float) -> void:
	super(delta)
	update_lazer_line_2d()
	pass


func update_lazer_line_2d() -> void:
	
	pass

func setup_projectile_lazer_line_2d() -> void:
	if projectile_lazer_line_2d: return
	projectile_lazer_line_2d = Line2D.new()
	projectile_lazer_line_2d.texture = texture
	projectile_lazer_line_2d.texture_mode = texture_mode
	projectile_lazer_line_2d.begin_cap_mode = begin_cap_mode
	pass
