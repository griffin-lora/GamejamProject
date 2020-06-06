extends TextureRect

var ability_textures = [
	"res://assets/ui_timestop.png",
	"res://icon.png",
	"res://assets/potion.png",
	"res://assets/lightning.png",
	"res://assets/lightning.png",
	"res://assets/lightning.png"
]

var last_ability_id = 0

func _process(delta):
	if last_ability_id != GlobalVars.ability_id:
		change_ability()

func change_ability():
	# i dont fucking know how to do this
	last_ability_id = GlobalVars.ability_id
	texture = load(ability_textures[GlobalVars.ability_id])
