extends TextureProgress

func _process(delta):
	if !GlobalVars.is_slow:
		if GlobalVars.ability_recharge_ct != 0:
			value = ((GlobalVars.ability_recharge_ct / GlobalVars.ability_recharge_time) * 100)
	else:
		var x = ((GlobalVars.slow_ticker / GlobalVars.slow_time) * 100)
		x = 0 + (100 - x)
		value = x
