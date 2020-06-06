extends TextureButton

var is_down = false
var data_point
var visualizer
var data_id
var point_index
var removed = false

func _ready():
	connect("pressed", self, "click")

func _physics_process(delta):
	if pressed and not removed and GlobalVars.level_data.path_points.size() > 2:
		removed = true
		visualizer.remove_point(point_index)
