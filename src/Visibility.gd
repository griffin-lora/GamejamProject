extends Control
var ready = false

onready var label = $Label
onready var label_backing = $LabelBacking

onready var win_screen = $WinScreen

func _ready():
	ready = true

func _process(delta):
	var current_scene = get_tree().get_current_scene()
	if ready and is_instance_valid(current_scene):
		visible = current_scene.mode == 0 and !GlobalVars.picking_ability
	label.text = "SCORE\n" + str(GlobalVars.score).pad_zeros(8)
	label_backing.text = label.text
	
	if current_scene.mode == 0:
		if current_scene.won:
			var color = win_screen.modulate
			color.a = lerp(color.a, 1, delta * 5)
			win_screen.modulate = color
		else:
			var color = win_screen.modulate
			color.a = lerp(color.a, 0, delta * 5)
			win_screen.modulate = color
	else:
		var color = win_screen.modulate
		color.a = lerp(color.a, 0, delta * 5)
		win_screen.modulate = color
