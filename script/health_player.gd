extends Node

#@export var health := 1.0
@export var stat :PlayerStats
var current_health :float
#var lost_health :float


@onready var health_bar: ProgressBar = get_tree().current_scene.get_node("UI/health_bar_player")
const HP_LOST_INDICATOR = preload("uid://cjvtav2pn62af")

func _ready() -> void:
	
	current_health = stat.health
	if health_bar:
		health_bar.max_value = current_health
		health_bar.value = current_health
	pass

func add_health(amount: float) -> void:
	current_health += amount
	if health_bar:
		health_bar.value = current_health

func remove_health(amount: float, _crit := false) -> void:
	current_health -= amount

	if _crit:
		#print("CRITICAL!", amount)
		pass

	if health_bar:
		health_bar.value = current_health

	if current_health <= 0:
		call_deferred("die")
	
	var hp_lost_indicator = HP_LOST_INDICATOR.instantiate()
	hp_lost_indicator.add_theme_color_override("font_color", Color.GREEN)
	hp_lost_indicator.global_position = get_parent().global_position
	get_tree().current_scene.add_child(hp_lost_indicator)
	hp_lost_indicator.add_label_text(amount,_crit)
	#print(current_health)
	
func die() -> void:

	#var hp_lost_indicator = HP_LOST_INDICATOR.instantiate()
	#hp_lost_indicator.add_label_text(lost_health)
	#hp_lost_indicator.global_position = get_parent().global_position
	#get_tree().current_scene.add_child(hp_lost_indicator)
		
	get_parent().queue_free()
