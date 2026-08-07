extends Node

#@export var health := 1.0
@export var stat :EnemyStat
var current_health :float
#var lost_health :float
@export var health_bar: TextureProgressBar
const BASE_ENEMY_STATS = preload("uid://ct2wc57bnp5oq")

const DROPPED_ORB = preload("uid://cny8nefj8h3jr")
const HP_LOST_INDICATOR = preload("uid://cjvtav2pn62af")

func _ready() -> void:
	
	stat = BASE_ENEMY_STATS
	#print(stat)
	current_health = stat.enemy_1_hp

	if health_bar:
		health_bar.max_value = current_health
		health_bar.value = current_health
	pass

func add_health(amount: float) -> void:
	current_health += amount
	if health_bar:
		health_bar.value = current_health

func remove_health(amount: float, crit := false) -> void:
	current_health -= amount

	if crit:
		#print("CRITICAL!", amount)
		pass

	if health_bar:
		health_bar.value = current_health

	if current_health <= 0:
		call_deferred("die")
	
	var hp_lost_indicator = HP_LOST_INDICATOR.instantiate()
	hp_lost_indicator.global_position = get_parent().global_position
	get_tree().current_scene.add_child(hp_lost_indicator)
	hp_lost_indicator.add_label_text(amount,crit)
	
	
func die() -> void:
	if get_parent().is_in_group("enemy"):
		var orb = DROPPED_ORB.instantiate()
		orb.global_position = get_parent().global_position
		get_tree().current_scene.add_child(orb)
		
	
		
	get_parent().queue_free()
