extends Node2D
class_name UpgradeTreeNode

@export var upgrade_data:UpgradeData
@export var child_upgrades: Array[UpgradeTreeNode] = []
var lines:Array[Line2D] = []
var pressed = false
var random_color:Color
const TOOLTIP = preload("uid://hf7fmrifbfpu")
var tooltip:Tooltip
@export var tooltip_offset = Vector2(20.0,20.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_color = Color.from_hsv(randf(), randf(), 1.0, 1.0)
	modulate = random_color
	update_visual()
	connect_line()
	pass # Replace with function body.

func connect_line():
	for child in child_upgrades:
		var line := Line2D.new()
		line.z_index = -1
		line.width = 9
		line.gradient = Gradient.new()
		line.gradient.colors = [Color(random_color, 1.0), Color(child.random_color, 1.0)]
		line.add_point(Vector2.ZERO)
		line.add_point(child.position - position)
		lines.append(line)
		add_child(line)
	pass

func update():
	for i in child_upgrades.size():
		child_upgrades[i].update()
		#lines[i].gradient.set_color(0,Color(0.83, 0.849, 0.0, 1.0))
		#lines[i].gradient.set_color(1,Color(0.85, 0.0, 0.0, 1.0))
		pass
	pass

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
	if LevelManager.orb < upgrade_data.orb_cost:
		print("denied")
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
		#tooltip.position = get_local_mouse_position()+tooltip_offset
		tooltip.position = to_local(global_position)+tooltip_offset
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
