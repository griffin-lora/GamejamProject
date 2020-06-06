extends TextureRect

var ability_textures = [
	"res://.import/ui_timestop.png-faf79de89573691e4253601788b09e93.stex",
	"res://icon.png",
	"res://icon.png",
	"res://icon.png",
	"res://icon.png",
	"res://icon.png"
]

var last_ability_id = 0

func _process(delta):
	if last_ability_id != GlobalVars.ability_id:
		change_ability()

func change_ability():
	# i dont fucking know how to do this
	last_ability_id = GlobalVars.ability_id
	texture = load(ability_textures[GlobalVars.ability_id])
