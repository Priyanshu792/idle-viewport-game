@tool
extends Node2D
class_name UpgradeTreeNode

@export var upgrade_data:UpgradeData
@export var child_upgrades: Array[UpgradeTreeNode] = []
var pressed = false

const TOOLTIP = preload("uid://hf7fmrifbfpu")
var tooltip:Tooltip
@export var tooltip_offset = Vector2(20.0,20.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_visual()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	if upgrade_data == null:
		return
	if pressed:
		return
	if upgrade_data.increment_update:
		upgrade_data.current_increment += 1
		if upgrade_data.current_increment >= upgrade_data.increment_max_value:
			pressed = true
	else:
		pressed = true
	update_visual()
	GameEvents.upgrade_buy.emit(upgrade_data)
	pass # Replace with function body.

func update_visual() -> void:
	if pressed:
		$scalable.scale = Vector2.ONE * 1.4
	else:
		$scalable.scale = Vector2.ONE

func _unhandled_input(_event: InputEvent) -> void:
	if pressed and upgrade_data.increment_update == false:
		$scalable.scale = Vector2.ONE * 1.4
	pass

func _on_mouse_entered() -> void:
	tooltip= TOOLTIP.instantiate()
	if InputEventMouseMotion:
		tooltip.position = get_local_mouse_position()+tooltip_offset
		pass
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
	update_visual()
	pass # Replace with function body.
