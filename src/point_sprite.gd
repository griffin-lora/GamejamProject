extends TextureButton

var is_down = false
var data_point
var visualizer
var data_id

func down():
	is_down = false#true
	
func up():
	is_down = false

func _ready():
	connect("button_down", self, "down")
	connect("button_up", self, "up")
	
func _physics_process(d):
	if is_down:
		rect_position = get_global_mouse_position()
		data_point = rect_position
		rect_position = data_point - (rect_size / 2)
		visualizer.curve.set_point_position(data_id, get_global_mouse_position())
		visualizer.update()
