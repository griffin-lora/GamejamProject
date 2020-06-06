extends Button

export var type := 0

var start_rect_pos : Vector2

func _ready():
	start_rect_pos = rect_position

func _process(delta):
	if is_hovered() and !pressed:
		modulate = Color(0.85, 0.85, 0.95)
		rect_scale = rect_scale.linear_interpolate(Vector2(1.08, 1.08), delta * 8)
		rect_position = rect_position.linear_interpolate(start_rect_pos - (rect_size * .04), delta * 8)
	else:
		modulate = Color(1, 1, 1)
		rect_scale = rect_scale.linear_interpolate(Vector2(1, 1), delta * 8)
		rect_position = rect_position.linear_interpolate(start_rect_pos, delta * 8)

func _pressed():
	if type == 0:
		get_tree().paused = !get_tree().paused
		if get_parent().get_parent().name == "PauseScreen":
			get_parent().get_parent().visible = get_tree().paused
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
		get_parent().get_parent().visible = get_tree().paused
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif type == 5:
		get_parent().visible = false
		get_parent().get_parent().get_node("AbilityScreen").visible = true
	elif type == 6:
		get_parent().visible = false
		get_parent().get_parent().get_node("MainScreen").visible = true
		get_tree().paused = !get_tree().paused
		get_parent().get_parent().visible = get_tree().paused
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
