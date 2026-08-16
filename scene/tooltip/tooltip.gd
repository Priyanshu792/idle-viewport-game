extends Panel
class_name Tooltip

#@onready var header: Label = $VBoxContainer/Panel/header
#@onready var description: Label = $VBoxContainer/HBoxContainer/Panel2/description
#@onready var cost: Label = $VBoxContainer/HBoxContainer/Panel3/VBoxContainer/cost



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_tooltip(_head:String,_describe:String,_cost:int):
	$VBoxContainer/Panel/header.text = _head
	$VBoxContainer/HBoxContainer/Panel2/description.text = _describe
	$VBoxContainer/HBoxContainer/Panel3/VBoxContainer/cost.text = str(_cost)
	pass
