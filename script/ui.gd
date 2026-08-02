extends Control

@onready var score_label: Label = %Score_Label

@onready var settings: Control = $settings
@onready var fire_rate: Button = $fire_rate
@onready var settings_button: Button = $SettingsButton


@export var score := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.enemy_killed.connect(_on_enemy_killed)
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


func _on_fire_rate_pressed() -> void:
	GameEvents.fire_rate.emit()
	pass # Replace with function body.
