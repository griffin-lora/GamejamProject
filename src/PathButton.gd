extends Button

export var editor_path : NodePath

onready var editor = get_node(editor_path)

func _pressed():
	editor.placing_obstacles = false
