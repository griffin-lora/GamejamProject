extends Control
var ready = false

onready var label = $Label
onready var label_backing = $LabelBacking

func _ready():
	ready = true

func _process(delta):
	var current_scene = get_tree().get_current_scene()
	if ready and is_instance_valid(current_scene):
		visible = current_scene.mode == 0
	label.text = "SCORE\n" + str(GlobalVars.score).pad_zeros(8)
	label_backing.text = label.text
