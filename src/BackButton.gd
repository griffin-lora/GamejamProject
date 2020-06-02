extends Button

func _process(delta):
	if is_hovered() and !pressed:
		modulate = Color(0.85, 0.85, 0.95)
	else:
		modulate = Color(1, 1, 1)

func _pressed():
	get_parent().visible = false
	get_parent().get_parent().get_node("BasePage").visible = true
	# this is peak coding
