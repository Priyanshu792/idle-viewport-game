extends Control

#@onready var option_button: OptionButton = $VBoxContainer/OptionButton
@onready var option_button: OptionButton = $VBoxContainer/HBoxContainer/VBoxContainer2/OptionButton
@onready var option_button_2: OptionButton = $VBoxContainer/HBoxContainer/VBoxContainer2/OptionButton2
@onready var option_button_3: OptionButton = $VBoxContainer/HBoxContainer/VBoxContainer2/OptionButton3

@onready var custom_res: HBoxContainer = $VBoxContainer/HBoxContainer/VBoxContainer2/custom_res
@onready var custom_res_val_1: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer2/custom_res/custom_res_val1
@onready var custom_res_val_2: LineEdit = $VBoxContainer/HBoxContainer/VBoxContainer2/custom_res/custom_res_val2

var custom_size:Vector2i
var current_size = DisplayServer.window_get_size()

#const RESOLUTIONS: Array[Vector2i] = [
	#Vector2i(504, 504),
	#Vector2i(320, 180),
	#Vector2i(640, 360),
	#Vector2i(960, 540),
	#Vector2i(1280, 720),
	#Vector2i(1920, 1032),
#]
var RESOLUTIONS: Array[String] = [
	"504X504",
	"320X180",
	"640X360",
	"960X540",
	"1280X720",
	"1920X1032",
	"CUSTOM"
]


func _ready():
	var screen_count = DisplayServer.get_screen_count()
	for i in range(screen_count):
		option_button_3.add_item(str(i))
	
	option_button.clear()

	option_button.add_item("Top Left")
	option_button.add_item("Top Center")
	option_button.add_item("Top Right")
	option_button.add_item("Center Left")
	option_button.add_item("Center")
	option_button.add_item("Center Right")
	option_button.add_item("Bottom Left")
	option_button.add_item("Bottom Center")
	option_button.add_item("Bottom Right")

	# Show the currently saved selection
	option_button.select(WindowsManager.anchor)

	#option_button.item_selected.connect(_on_option_selected)
	
	option_button_2.clear()
	
	# Loop through the list to add text items (e.g., "1920 x 1080")
	for res in RESOLUTIONS:
		#option_button_2.add_item(str(res.x) + " x " + str(res.y))
		option_button_2.add_item(res)
	
	#var current_size = DisplayServer.window_get_size()
	var current_size_string = "%dX%d" % [current_size.x, current_size.y]
	#print("%d"%current_size.x)
	var current_index = RESOLUTIONS.find(current_size_string)
	if current_index != -1:
		option_button_2.select(current_index)




func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	#print(get_parent().get_node("settings"))
	get_parent().get_node("settings").hide()
	if get_parent().get_node("SettingsButton"):
		get_parent().get_node("SettingsButton").show()
	if get_parent().get_node("VBoxContainer"):
		get_parent().get_node("VBoxContainer").show()


func _on_option_button_item_selected(index: int) -> void:
	WindowsManager.set_anchor(index)
	pass # Replace with function body.


func _on_option_button_2_item_selected(index: int) -> void:
	WindowsManager.apply_resolution(index)
	pass
'''	var res := RESOLUTIONS[index]

	if res == "CUSTOM":
		custom_res.show()
		return

	custom_res.hide()

	var res_split := res.split("X")
	var size := Vector2i(int(res_split[0]),int(res_split[1]))

	DisplayServer.window_set_size(size)
	GameEvents.resolution_changed.emit(size.x, size.y)'''


func _on_custom_res_val_1_text_submitted(new_text: String) -> void:
	_apply_custom_resolution()


func _on_custom_res_val_2_text_submitted(new_text: String) -> void:
	_apply_custom_resolution()


func _apply_custom_resolution() -> void:
	if custom_res_val_1.text.is_empty() or custom_res_val_2.text.is_empty():
		return

	var width := int(custom_res_val_1.text)
	var height := int(custom_res_val_2.text)
	
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
		option_button_2.add_item(resolution_string)

	option_button_2.select(RESOLUTIONS.find(resolution_string))


func _on_option_button_3_item_selected(index: int) -> void:
	WindowsManager.set_current_screen(index)
	pass # Replace with function body.


func _on_debug_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	var size = DisplayServer.window_get_size()
	player.position = size/2.0
	#print(size)
	pass # Replace with function body.
