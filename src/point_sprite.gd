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
	if pressed and not removed:
		removed = true
		visualizer.remove_point(point_index)
