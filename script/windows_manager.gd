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

var anchor: WindowAnchor = WindowAnchor.BOTTOM_RIGHT

func _ready():
	load_settings()
	apply_window_settings()

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
	var config := ConfigFile.new()
	config.set_value("window", "anchor", anchor)
	config.save(SETTINGS_PATH)

func load_settings():
	var config := ConfigFile.new()

	if config.load(SETTINGS_PATH) == OK:
		anchor = config.get_value("window","anchor",WindowAnchor.BOTTOM_RIGHT)

func get_game_state():
	
	pass
