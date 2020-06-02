extends TextureProgress

func _process(delta):
	if GlobalVars.ability_recharge_ct != 0:
		value = 100#((GlobalVars.ability_recharge_time / GlobalVars.ability_recharge_ct) * 100)
		# epic gamer moment
