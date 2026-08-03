extends Node2D


var damage := 0.0
var is_crit := false

const EXPLOSION_PARTICLE = preload("uid://rmf1psipscka")

#var direction := Vector2.ZERO


func _physics_process(delta):
	#position += direction * speed * delta
	pass

func setup(player_stats: PlayerStats, weapon_stats: WeaponsStat):
	var result = DamageCalculator.get_damage(
		player_stats,
		weapon_stats.spread_fire_damage
	)

	damage = result.damage
	is_crit = result.is_crit

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var enemy_health = body.get_node("health")
		
		enemy_health.remove_health(damage, is_crit)
		
		
		#queue_free()         # Destroy projectile
		if enemy_health.current_health <= 0.0:
			var dying_explosion = EXPLOSION_PARTICLE.instantiate()
			dying_explosion.global_transform = global_transform
			get_tree().current_scene.add_child(dying_explosion)
			GameEvents.enemy_killed.emit()
			body.queue_free()    # Despawn enemy
			dying_explosion.explode()
			
		get_parent().get_parent().queue_free()
		
	if body.is_in_group("walls"):
		get_parent().get_parent().queue_free()  
