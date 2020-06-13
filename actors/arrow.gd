extends Node2D

export var regular_texture : AnimatedTexture
export var ghost_texture : StreamTexture

func _ready():
	if GlobalVars.level_data.theme == 3:
		$Sprite.texture = ghost_texture
		rotation = 0
