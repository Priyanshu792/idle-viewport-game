extends Control

# Define pairs of node paths that connect (Prerequisite -> Next Upgrade)
@export var connections : Array[NodePath] = []

func _ready():
	# Force a redraw when the scene loads
	queue_redraw()

func _draw():
	# Set the color and thickness for your upgrade branch lines
	var line_color = Color(0.632, 0.978, 0.0, 1.0) 
	var line_thickness = 4.0
	print(connections.size())
	# Loop through connected button pairs and draw lines between their centers
	for i in range(connections.size() - 1):
		var node_a = get_node_or_null(connections[i]) as Control
		var node_b = get_node_or_null(connections[i + 1]) as Control
		if node_a and node_b:
			var start_pos = node_a.position + node_a.size / 2
			var end_pos = node_b.position + node_b.size / 2
			draw_line(start_pos, end_pos, line_color, line_thickness, true)
