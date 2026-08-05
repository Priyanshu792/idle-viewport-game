extends Control

@onready var main: Node2D = $".."

@onready var score_label: Label = %Score_Label
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_bar: ProgressBar = $health_bar

@onready var settings: Control = $settings

@onready var settings_button: Button = $SettingsButton

@onready var orbs_label: Label = $Orbs_Label

@export var score := 0

@onready var upgrade_button: Button = $Upgrade_Button
@onready var upgrade_menu: Control = $upgrade_menu

var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	GameEvents.enemy_killed.connect(_on_enemy_killed)
	GameEvents.orb.connect(_on_orb_collected)
	orbs_label.text = str(LevelManager.level)
	progress_bar.max_value = LevelManager.xp_to_next
	#health_bar.max_value = player.
	pass # Replace with function body.



func _on_settings_button_pressed() -> void:
	get_tree().paused = true
	settings.show()
	settings_button.hide()
	pass # Replace with function body.

func add_score(num:int):
	score+=num
	pass

func remove_score(num:int):
	score-=num
	pass

func _on_enemy_killed():
	add_score(1)
	score_label.text = str(score)
	pass

func _on_orb_collected():
	orbs_label.text = str(LevelManager.level)
	progress_bar.max_value = LevelManager.xp_to_next
	progress_bar.value = LevelManager.xp


func _on_upgrade_button_pressed() -> void:
	#upgrade_menu.show()
	#get_tree().paused = true
	pass # Replace with function body.
