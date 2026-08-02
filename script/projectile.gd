extends Node2D

@export var speed := 600.0
@export var damage := 0.5

const EXPLOSION_PARTICLE = preload("uid://rmf1psipscka")

var direction := Vector2.ZERO


func _physics_process(delta):
	position += direction * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var enemy_health = body.get_node("health")
		
		enemy_health.remove_health(damage)
		
		queue_free()         # Destroy projectile
		if enemy_health.health<=0.0:
			var dying_explosion = EXPLOSION_PARTICLE.instantiate()
			dying_explosion.global_transform = global_transform
			get_tree().current_scene.add_child(dying_explosion)
			GameEvents.enemy_killed.emit()
			body.queue_free()    # Despawn enemy
			dying_explosion.explode()
	if body.is_in_group("walls"):
		queue_free()  
