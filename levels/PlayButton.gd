extends Button

export var button_type := 0

var down = false

func _ready():
	connect("button_down", self, "down")
	connect("button_up", self, "up")

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
