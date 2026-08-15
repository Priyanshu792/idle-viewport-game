extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	#var parent = get_tree().current_scene.get_node("/root/main/UI/UpgradeTree")
	get_parent().get_node("UpgradeTree").hide()
	get_tree().paused = false
	#parent.visible = false
	pass # Replace with function body.
