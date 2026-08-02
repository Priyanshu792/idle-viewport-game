extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton


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

	option_button.item_selected.connect(_on_option_selected)

func _on_option_selected(index: int):
	WindowsManager.set_anchor(index)


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	#print(get_parent().get_node("settings"))
	get_parent().get_node("settings").hide()
	if get_parent().get_node("SettingsButton"):
		get_parent().get_node("SettingsButton").show()
	if get_parent().get_node("VBoxContainer"):
		get_parent().get_node("VBoxContainer").show()
