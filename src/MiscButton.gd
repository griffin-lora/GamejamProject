extends Button

export var type := 0

func _process(delta):
	if is_hovered() and !pressed:
		modulate = Color(0.85, 0.85, 0.95)
	else:
		modulate = Color(1, 1, 1)

func _pressed():
	if type == 0:
		GlobalVars.return_to_title()
	elif type == 1:
		if get_tree().get_current_scene().mode == 1:
			OS.clipboard = GlobalVars.level_data.encode()
		elif get_tree().get_current_scene().mode == 0:
			var level_list = load("res://level_list.tres")
			var level_name = level_list.levels[GlobalVars.level_id]
			var level_contents = load("res://assets/levels/" + level_name + ".tres")
			OS.clipboard = level_contents.data
	elif type == 2:
		GlobalVars.level_data.decode(OS.clipboard)
		get_tree().reload_current_scene()
	elif type == 3:
		get_tree().get_current_scene().test_level()
	elif type == 4:
		get_tree().paused = !get_tree().paused
		get_parent().visible = get_tree().paused
