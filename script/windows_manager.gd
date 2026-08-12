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

var RESOLUTIONS: Array[String] = [
	"504X504",
	"320X180",
	"640X360",
	"960X540",
	"1280X720",
	"1920X1032",
	"CUSTOM"
]

const SETTINGS_PATH := "res://configs.cfg"
var config := ConfigFile.new()

var anchor: WindowAnchor = WindowAnchor.BOTTOM_RIGHT
var screen_idx := 0
var screen_count = DisplayServer.get_screen_count()
var current_screen = DisplayServer.window_get_current_screen()

var resolution_idx := 0
var custom_size:Vector2i

func _ready():
	load_settings()
	set_resolution()
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
	config.set_value("window", "resolution", resolution_idx)
	config.set_value("window", "screen", screen_idx)
	config.save(SETTINGS_PATH)

func load_settings():
	var config := ConfigFile.new()

	if config.load(SETTINGS_PATH) == OK:
		anchor = config.get_value("window","anchor",WindowAnchor.BOTTOM_RIGHT)
		screen_idx = config.get_value("window","screen")
		resolution_idx = config.get_value("window","resolution")

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

func apply_resolution(index):
	resolution_idx = index
	set_resolution()
	save_settings()
	pass

func apply_custom_resolution(custom_res_val_1,custom_res_val_2):
	#resolution_idx = index
	set_custom_resolution(custom_res_val_1,custom_res_val_2)
	save_settings()
	pass

func set_resolution():
	var res := RESOLUTIONS[resolution_idx]
	if res == "CUSTOM":
		#custom_res.show()
		return
	var res_split := res.split("X")
	var size := Vector2i(int(res_split[0]),int(res_split[1]))
	DisplayServer.window_set_size(size)
	GameEvents.resolution_changed.emit(size.x,size.y)
	pass

func set_custom_resolution(custom_res_val_1,custom_res_val_2):
	var width := int(custom_res_val_1)
	var height := int(custom_res_val_2)
	
	width = clampi(width, 320, 1920)
	height = clampi(height, 180, 1080)
	
	if width <= 0 or height <= 0:
		return

	custom_size = Vector2i(width, height)

	DisplayServer.window_set_size(custom_size)
	GameEvents.resolution_changed.emit(custom_size.x, custom_size.y)
	
	var resolution_string := "%dX%d" % [custom_size.x, custom_size.y]

	if not RESOLUTIONS.has(resolution_string):
		RESOLUTIONS.insert(RESOLUTIONS.size() - 1, resolution_string)
	pass
