extends Control
var ready = false

func _ready():
	ready = true

func _process(delta):
	var current_scene = get_tree().get_current_scene()
	if ready and is_instance_valid(current_scene):
		visible = current_scene.mode == 0
