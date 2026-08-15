@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	for n in get_children():
		var utn:UpgradeTreeNode = n 
		for c in utn.child_upgrades:
			draw_line(n.position,to_local(c.position),Color.WHITE,3)
			pass
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	pass
