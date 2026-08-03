class_name DamageCalculator


static func get_damage(player_stats: PlayerStats, weapon_damage: float) -> Dictionary:
	var final_damage = weapon_damage
	var critical = false

	if randf() < player_stats.crit_chance:
		critical = true
		final_damage *= player_stats.crit_multiplier

	return {
		"damage": final_damage,
		"is_crit": critical
	}
