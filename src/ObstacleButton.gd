extends TextureButton

export var obstacle_id := 0
export var editor_path : NodePath

onready var editor = get_node(editor_path)

func _pressed():
	editor.selected_obstacle = obstacle_id
	editor.update_selected_obstacle()
