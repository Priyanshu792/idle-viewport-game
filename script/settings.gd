extends Control

#@onready var option_button: OptionButton = $VBoxContainer/OptionButton
@onready var option_button: OptionButton = $HBoxContainer/VBoxContainer2/OptionButton
@onready var option_button_2: OptionButton = $HBoxContainer/VBoxContainer2/OptionButton2

const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(504, 504),
	Vector2i(320, 180),
	Vector2i(640, 360),
	Vector2i(960, 540),
	Vector2i(1280, 720),
	Vector2i(1920, 1032)
]

func _ready():
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
		option_button_2.add_item(str(res.x) + " x " + str(res.y))
	
	var current_size = DisplayServer.window_get_size()
	var current_index = RESOLUTIONS.find(current_size)
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
	var res = RESOLUTIONS[index]
	DisplayServer.window_set_size(res)
	GameEvents.resolution_changed.emit(res.x, res.y)
	#GameEvents.resolution_changed.emit(res.x, res.y)
	pass # Replace with function body.
