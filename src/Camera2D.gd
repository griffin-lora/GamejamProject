extends Camera2D

export var character : NodePath

onready var character_node = get_node(character)

var rotation_speed = 3

func _physics_process(delta):
	position = character_node.center_pos
	rotation = lerp_angle(rotation, character_node.base_rotation, delta * rotation_speed)
