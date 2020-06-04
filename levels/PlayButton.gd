extends Button

export var button_type := 0

var down = false
var hovering = false

var tick = 0

func _ready():
	connect("button_down", self, "down")
	connect("button_up", self, "up")
	connect("mouse_entered", self, "hover")
	connect("mouse_exited", self, "unhover")

func hover():
	hovering = true
	
func unhover():
	hovering = false

func down():
	down = true

func up():
	if down:
		click()
	down = false
	
func click():
	if button_type == 0:
		GlobalVars.enter_play_mode()
	elif button_type == 1:
		GlobalVars.enter_editor_mode()

func _process(delta):
	if hovering:
		tick += delta
		rect_rotation = sin(tick * 2) * 20
	else:
		tick = 0
		rect_rotation = 0
