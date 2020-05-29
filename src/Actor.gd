extends Node2D

export var reaction_speed = 17.5
export var rotation_speed = 12.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	position = position.linear_interpolate(mouse_pos, delta * reaction_speed)
	rotation_degrees = lerp(rotation_degrees, clamp(mouse_pos.y - position.y, -35, 35), delta * rotation_speed)
