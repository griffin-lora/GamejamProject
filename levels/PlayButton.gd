extends Button

export var button_type := 0

export var hovered_outline_color : Color
export var normal_outline_color : Color

export var hovered_color : Color
export var normal_color : Color

var down = false
var hovering = false

onready var label = $Label

var tick = 0

func _ready():
	connect("button_down", self, "down")
	connect("button_up", self, "up")
	connect("mouse_entered", self, "hover")
	connect("mouse_exited", self, "unhover")
	label.add_color_override("font_color", normal_color)
	label.add_color_override("font_outline_modulate", normal_outline_color)
	
	if button_type == 1 and OS.get_name() != "Windows":
		queue_free()

func hover():
	hovering = true
	label.add_color_override("font_color", hovered_color)
	label.add_color_override("font_outline_modulate", hovered_outline_color)
	
func unhover():
	hovering = false
	label.add_color_override("font_color", normal_color)
	label.add_color_override("font_outline_modulate", normal_outline_color)

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
	elif button_type == 2:
		GlobalVars.credits_from_title = true
		get_tree().change_scene("res://levels/credits.tscn")

func _process(delta):
	if hovering:
		tick += delta
		rect_rotation = sin(tick * 2) * 5
	else:
		tick = 0
		rect_rotation = lerp(rect_rotation, 0, delta * 4)
