extends Control

@onready var settings: Control = $settings
@onready var settings_button: Button = $SettingsButton
@onready var v_box_container: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	settings.show()
	v_box_container.hide()
	settings_button.hide()
	pass # Replace with function body.
