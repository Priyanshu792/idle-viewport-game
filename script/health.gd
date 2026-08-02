extends Node

@export var health := 1.0
@onready var health_bar: TextureProgressBar = $"../health_bar"

const DROPPED_ORB = preload("uid://cny8nefj8h3jr")

func add_health(amount: float) -> void:
	health += amount
	health_bar.value = health

func remove_health(amount: float) -> void:
	health -= amount
	health_bar.value = health

	if health <= 0:
		call_deferred("die")

func die() -> void:
	var orb = DROPPED_ORB.instantiate()
	orb.global_position = get_parent().global_position
	get_tree().current_scene.add_child(orb)

	get_parent().queue_free()
