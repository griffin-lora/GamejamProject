extends Control

onready var sprite = $AbilitySprite
onready var arrow_left = $Left
onready var arrow_right = $Right
onready var label = get_node("../Info")
onready var backing = get_node("../Backing")

var ability_textures = [
	"res://assets/ui_timestop.png",
	"res://icon.png",
	"res://assets/potion.png",
	"res://assets/lightning.png",
	"res://assets/lightning.png",
	"res://assets/lightning.png"
]

var ability_descriptions = [
	"Slows down time to half speed",
	"res://icon.png",
	"Rewinds time after you die",
	"Shrinks you to a third of your size",
	"res://assets/lightning.png",
	"res://assets/lightning.png"
]

func _ready():
	arrow_left.connect("pressed", self, "press")
	arrow_right.connect("pressed", self, "press")
	
func press():
	if arrow_left.pressed:
		GlobalVars.ability_id -= 1
		if GlobalVars.ability_id == 1:
			GlobalVars.ability_id -= 1
		GlobalVars.ability_id = wrapi(GlobalVars.ability_id, 0, 4)
	elif arrow_right.pressed:
		GlobalVars.ability_id += 1
		if GlobalVars.ability_id == 1:
			GlobalVars.ability_id += 1
		GlobalVars.ability_id = wrapi(GlobalVars.ability_id, 0, 4)
	change_ability()

func change_ability():
	sprite.texture = load(ability_textures[GlobalVars.ability_id])
	label.text = ability_descriptions[GlobalVars.ability_id]
	backing.text = label.text
	GlobalVars.slow_ticker = 0
	GlobalVars.is_slow = false
