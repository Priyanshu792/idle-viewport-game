extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0

@onready var nodes: Node2D = $"../Nodes"

var is_dragging: bool = false
var size:Vector2

var map_limits: Rect2 = Rect2(0,0,1920,1920)
func _ready() -> void:
	#position = nodes.get_child(0).position
	#GameEvents.connect("resolution_changed",set_bounds)
	#size = DisplayServer.window_get_size()
	#set_bounds(size.x,size.y)
	#limit_left = int(map_limits.position.x)
	#limit_top = int(map_limits.position.y)
	#limit_right = int(map_limits.end.x)
	#limit_bottom = int(map_limits.end.y)

	pass

func set_bounds(width:int,height:int):
	limit_left = -width
	limit_right = width
	limit_top = -height
	limit_bottom = height
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(zoom_speed, event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(-zoom_speed, event.position)

	elif event is InputEventMouseMotion and is_dragging:
		position -= event.relative / zoom

func zoom_camera(zoom_increment: float, _mouse_pos: Vector2) -> void:
	var new_zoom = zoom + Vector2.ONE * zoom_increment
	new_zoom = new_zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
	zoom = new_zoom
