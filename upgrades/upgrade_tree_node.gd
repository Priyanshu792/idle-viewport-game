@tool
extends Node2D
class_name UpgradeTreeNode

@export var upgrade_data:UpgradeData
@export var child_upgrades: Array[UpgradeTreeNode] = []
var pressed = false

const TOOLTIP = preload("uid://hf7fmrifbfpu")
var tooltip:Tooltip
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(upgrade_data)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				#$scalable.scale = Vector2.ONE * 1.4
				pressed = true
				GameEvents.upgrade_buy.emit(upgrade_data)
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	tooltip= TOOLTIP.instantiate()
	tooltip.position = get_local_mouse_position()
	tooltip.update_tooltip(
		upgrade_data.name,
		upgrade_data.description.replace("{x}", str(upgrade_data.value)),
		upgrade_data.orb_cost)
	add_child(tooltip)
	$scalable.scale = Vector2.ONE * 1.4
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	tooltip.queue_free()
	$scalable.scale = Vector2.ONE
	pass # Replace with function body.
