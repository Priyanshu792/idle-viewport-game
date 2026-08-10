extends Node2D
@onready var game_timer: Timer = %Game_Timer
@onready var progress_bar: ProgressBar = $UI/ProgressBar
@onready var settings_button: Button = $UI/SettingsButton

@onready var ui: Control = $UI

#var orb :int

func _ready() -> void:
	#update_game_bounds()
	
	GameEvents.resolution_changed.connect(update_game_bounds)
	#GameEvents.orb.connect(_on_orb_collected)
	get_window().mouse_passthrough = false
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT,true)
	DisplayServer.window_set_mouse_passthrough([])
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	#update_mouse_passthrough()
	Performance.add_custom_monitor("game/enemies",get_enemy_count)
	WindowsManager.update_walls(DisplayServer.window_get_size())
	ui.size.x = DisplayServer.window_get_size().x
	ui.size.y = DisplayServer.window_get_size().y
	progress_bar.size.x = DisplayServer.window_get_size().x
	pass # Replace with function body.

func update_game_bounds(width: int, height: int):
	WindowsManager.update_walls(Vector2(width, height))
	ui.size.x = width
	ui.size.y = height
	progress_bar.size.x = DisplayServer.window_get_size().x

func update_mouse_passthrough():
	var rect = settings_button.get_global_rect()

	var polygon := PackedVector2Array([
		rect.position,
		rect.position + Vector2(rect.size.x, 0),
		rect.position + rect.size,
		rect.position + Vector2(0, rect.size.y)
	])

	get_window().mouse_passthrough_polygon = polygon

func signal_test():
	#print("hewo")
	pass

func _process(_delta: float) -> void:
	#get_window().mouse_passthrough_polygon = $Polygon2D.polygon
	var game_time = game_timer.wait_time - game_timer.time_left
	#progress_bar.value = game_time
	#print(game_timer.wait_time-game_timer.time_left)
	if game_time == 60:
		GameEvents.level_mark.emit(game_time)
	#print(progress_bar.value)
	#game_timer.time_left
	pass

func get_enemy_count():
	return get_tree().get_nodes_in_group("enemy").size()
	

func _on_orb_collected():
	#orb+=1
	#LevelManager.add_xp(1)
	pass
	
