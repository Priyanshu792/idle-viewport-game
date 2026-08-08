extends Node

enum WindowAnchor {
	TOP_LEFT,
	TOP_CENTER,
	TOP_RIGHT,
	CENTER_LEFT,
	CENTER,
	CENTER_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_CENTER,
	BOTTOM_RIGHT
}

const SETTINGS_PATH := "res://configs.cfg"
var config := ConfigFile.new()

var anchor: WindowAnchor = WindowAnchor.BOTTOM_RIGHT
var screen_idx := 0
var screen_count = DisplayServer.get_screen_count()
var current_screen = DisplayServer.window_get_current_screen()

func _ready():
	load_settings()
	apply_window_settings()
	set_current_screen(screen_idx)

func apply_window_settings():
	var screen := DisplayServer.screen_get_usable_rect()
	var window_size := DisplayServer.window_get_size()

	var pos := Vector2i.ZERO

	match anchor:
		WindowAnchor.TOP_LEFT:pos = Vector2i(0, 0)

		WindowAnchor.TOP_CENTER:pos = Vector2i((screen.size.x - window_size.x) / 2,0)

		WindowAnchor.TOP_RIGHT:pos = Vector2i(screen.size.x - window_size.x,0)

		WindowAnchor.CENTER_LEFT:pos = Vector2i(0,(screen.size.y - window_size.y) / 2)

		WindowAnchor.CENTER:pos = Vector2i((screen.size.x - window_size.x) / 2,(screen.size.y - window_size.y) / 2)

		WindowAnchor.CENTER_RIGHT:pos = Vector2i(screen.size.x - window_size.x,(screen.size.y - window_size.y) / 2)

		WindowAnchor.BOTTOM_LEFT:pos = Vector2i(0,screen.size.y - window_size.y)

		WindowAnchor.BOTTOM_CENTER:pos = Vector2i((screen.size.x - window_size.x) / 2,screen.size.y - window_size.y)

		WindowAnchor.BOTTOM_RIGHT:pos = Vector2i(screen.size.x - window_size.x,screen.size.y - window_size.y)

	DisplayServer.window_set_position(screen.position + pos)

func set_anchor(new_anchor: WindowAnchor):
	anchor = new_anchor
	save_settings()
	apply_window_settings()

func save_settings():
	config.set_value("window", "anchor", anchor)
	config.set_value("window", "screen", screen_idx)
	config.save(SETTINGS_PATH)

func load_settings():
	var config := ConfigFile.new()

	if config.load(SETTINGS_PATH) == OK:
		anchor = config.get_value("window","anchor",WindowAnchor.BOTTOM_RIGHT)
		screen_idx = config.get_value("window","screen")

func get_game_state():
	
	pass
	
	
func update_walls(size:Vector2):
	var walls = get_tree().get_nodes_in_group("walls")
	#print(walls)
	for wall in walls:
		if !(wall is CollisionShape2D):
			continue
		match wall.name:
			"Top":
				wall.position = Vector2(size.x / 2, 0)
				#print("Top ", wall.position)
			"Bottom":
				wall.position = Vector2(size.x / 2, size.y)
				#print("Bottom ", wall.position)
			"Left":
				wall.position = Vector2(0, size.y / 2)
				#print("Left ", wall.position)
			"Right":
				wall.position = Vector2(size.x, size.y / 2)
				#print("Right ", wall.position)
#	
	load_settings()
	apply_window_settings()

func set_current_screen(idx:int):
	screen_idx = idx
	if screen_idx < screen_count:
		DisplayServer.window_set_current_screen(screen_idx)
		pass
	save_settings()
	pass
