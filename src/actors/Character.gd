extends Actor

var center_pos := Vector2()

onready var sprite = $Sprite

export var reaction_speed = 17.5
export var rotation_speed = 12.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	center_pos = Vector2(center_pos.x + 1, center_pos.y)
	var relative_pos = position - center_pos
	var mouse_pos = get_global_mouse_position()
	relative_pos = relative_pos.linear_interpolate(mouse_pos, delta * reaction_speed)
	position = center_pos + relative_pos
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, clamp(mouse_pos.y - relative_pos.y, -35, 35), delta * rotation_speed)
