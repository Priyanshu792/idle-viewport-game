extends Node2D

@onready var upgradetree_camera: Camera2D = $upgradetree_camera
@onready var control: CanvasLayer = $upgradetree_camera/Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgradetree_camera.position = get_node("Nodes").get_child(0).position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	#var parent = get_tree().current_scene.get_node("/root/main/UI/UpgradeTree")
	get_parent().get_node("UpgradeTree").hide()
	get_tree().paused = false
	upgradetree_camera.enabled = false
	upgradetree_camera.position = get_node("Nodes").get_child(0).position
	control.visible = false
	#parent.visible = false
	pass # Replace with function body.


func _on_upgrade_button_pressed() -> void:
	upgradetree_camera.enabled = true
	control.visible = true
	pass # Replace with function body.
