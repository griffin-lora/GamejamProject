extends TextureButton

var is_down = false

func down():
	is_down = true
	
func up():
	is_down = false

func _ready():
	connect("button_down", self, "down")
	connect("button_up", self, "up")
	
func _process(d):
	if is_down:
		rect_position = get_global_mouse_position()
