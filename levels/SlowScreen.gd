extends Sprite

func _process(d):
	visible = GlobalVars.is_slow and GlobalVars.ability_id == 0
