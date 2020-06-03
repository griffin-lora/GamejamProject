extends Camera2D

export var character : NodePath

onready var character_node = get_node(character)

var rotation_speed = 3
var intensity = 3

export var max_offset = Vector2(100, 75)
export var max_roll = 0.1

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	force_update_scroll()

func _physics_process(delta):
	position = character_node.center_pos
	rotation = lerp_angle(rotation, character_node.base_rotation, delta * rotation_speed)
	
	if character_node.shake_time > 0:
		var amount = character_node.shake_time / 4
		noise_y += 1
		#rotation += max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
		offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
		offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
