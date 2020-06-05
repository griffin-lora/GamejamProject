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
		OS.clipboard = GlobalVars.level_data.encode()
	elif type == 2:
		GlobalVars.level_data.decode(OS.clipboard)
		get_tree().reload_current_scene()
