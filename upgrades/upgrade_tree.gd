#@tool
extends Node2D

#var line_2d:Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	#for n:UpgradeTreeNode in get_children():
		#var utn:UpgradeTreeNode = n 
		#for c in utn.upgrade_data.children:
			#var new_line:Line2D = line_2d.duplicate()
			#new_line.add_point(n.position)
			#new_line.add_point(c.position)
			#add_child(new_line)
			#var points:Array[Vector2]= [n.position,to_local(c.position)]
			#draw_circle(n.position,4.5,Color.POWDER_BLUE)
			#draw_line(n.position,to_local(c.position),Color.POWDER_BLUE,9)
			#draw_line(n.position,to_local(c.position),Color.LIGHT_STEEL_BLUE,6)
			#draw_polyline(points,Color.WHITE,3)
			#pass
		#pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	pass
