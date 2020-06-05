extends TextureButton

export var obstacle_id := 0
export var editor_path : NodePath
export var is_theme := false

onready var editor = get_node(editor_path)

func _process(delta):
	if is_hovered() and !pressed:
		modulate = Color(0.85, 0.85, 0.95)
	else:
		modulate = Color(1, 1, 1)

func _pressed():
	if !is_theme:
		editor.selected_obstacle = obstacle_id
		editor.update_selected_obstacle()
		editor.placing_obstacles = true
	else:
		GlobalVars.level_data.theme = obstacle_id
		get_tree().reload_current_scene()
