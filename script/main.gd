extends Node2D
@onready var game_timer: Timer = %Game_Timer
@onready var progress_bar: ProgressBar = $UI/ProgressBar

#var orb :int

func _ready() -> void:
	#GameEvents.orb.connect(_on_orb_collected)
	get_window().mouse_passthrough = false
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT,true)
	DisplayServer.window_set_mouse_passthrough([])
	Performance.add_custom_monitor("game/enemies",get_enemy_count)
	
	pass # Replace with function body.

func signal_test():
	print("hewo")
	pass

func _process(delta: float) -> void:
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
	pass

func _on_orb_collected():
	#orb+=1
	#LevelManager.add_xp(1)
	pass
