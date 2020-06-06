extends TextureProgress

func _process(delta):
	if !GlobalVars.is_slow:
		value = ((GlobalVars.ability_recharge_ct / GlobalVars.ability_recharge_time) * 100)
	else:
		var x = ((GlobalVars.slow_ticker / GlobalVars.slow_time) * 100)
		x = 0 + (100 - x)
		value = x
