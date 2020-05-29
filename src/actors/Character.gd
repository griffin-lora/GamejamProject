extends Actor

var center_pos := Vector2()

onready var sprite = $Sprite

export var reaction_speed = 17.5
export var rotation_speed = 12.5

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _process(delta):
	center_pos = Vector2(center_pos.x + 1, center_pos.y)
	var mouse_pos = get_global_mouse_position()
	position = position.linear_interpolate(mouse_pos, delta * reaction_speed)
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, clamp(mouse_pos.y - position.y, -35, 35), delta * rotation_speed)
