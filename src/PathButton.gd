extends Button

export var editor_path : NodePath

onready var editor = get_node(editor_path)

func _process(delta):
	if is_hovered() and !pressed:
		modulate = Color(0.85, 0.85, 0.95)
	else:
		modulate = Color(1, 1, 1)

func _pressed():
	editor.placing_obstacles = false
