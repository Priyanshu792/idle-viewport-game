extends Node

#@export var health := 1.0
@export var stat : EnemyStat
var current_health :float
@export var health_bar: TextureProgressBar

const DROPPED_ORB = preload("uid://cny8nefj8h3jr")

func _ready() -> void:
	current_health = stat.enemy_1_hp

	if health_bar:
		health_bar.max_value = current_health
		health_bar.value = current_health
	pass

func add_health(amount: float) -> void:
	stat.enemy_1_hp += amount
	if health_bar:
		health_bar.value = stat.enemy_1_hp

func remove_health(amount: float, crit := false) -> void:
	current_health -= amount

	if crit:
		print("CRITICAL!", amount)

	if health_bar:
		health_bar.value = current_health

	if current_health <= 0:
		call_deferred("die")

func die() -> void:
	if get_parent().is_in_group("enemy"):
		var orb = DROPPED_ORB.instantiate()
		orb.global_position = get_parent().global_position
		get_tree().current_scene.add_child(orb)
	
	get_parent().queue_free()
