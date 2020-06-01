extends Camera2D

var speed = 16

func _check_edges():
	var screen_size = get_viewport_rect().size
	var min_pos = Vector2(position.x - (screen_size.x/2), position.y - (screen_size.y/2))
	var max_pos = Vector2(position.x + (screen_size.x/2), position.y + (screen_size.y/2))
	if min_pos.x < limit_left:
		position.x = limit_left + (screen_size.x/2)
	if max_pos.x > limit_right:
		position.x = limit_right - (screen_size.x/2)
		
	if min_pos.y < limit_top:
		position.y = limit_top + (screen_size.y/2)
	if max_pos.y > limit_bottom:
		position.y = limit_bottom - (screen_size.y/2)

func _physics_process(delta):
	if Input.is_action_pressed("editor_left"):
		position.x -= speed
		_check_edges()
	if Input.is_action_pressed("editor_right"):
		position.x += speed
		_check_edges()
	if Input.is_action_pressed("editor_up"):
		position.y -= speed
		_check_edges()
	if Input.is_action_pressed("editor_down"):
		position.y += speed
		_check_edges()
