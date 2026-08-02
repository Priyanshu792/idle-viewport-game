extends Node2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var path_follow_2d_2: PathFollow2D = $Path2D2/PathFollow2D2
@onready var path_follow_2d_3: PathFollow2D = $Path2D3/PathFollow2D3
@onready var path_follow_2d_4: PathFollow2D = $Path2D4/PathFollow2D4
@onready var path_follow_2d_5: PathFollow2D = $Path2D5/PathFollow2D5

@onready var path_2d: Path2D = $Path2D
@onready var path_2d_2: Path2D = $Path2D2
@onready var path_2d_3: Path2D = $Path2D3
@onready var path_2d_4: Path2D = $Path2D4
@onready var path_2d_5: Path2D = $Path2D5

@onready var speed := 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#path_follow_2d.progress_ratio+=0.01
	#path_follow_2d_2.progress_ratio+=0.01
	#path_follow_2d_3.progress_ratio+=0.01
	#path_follow_2d_4.progress_ratio+=0.01
	#path_follow_2d_5.progress_ratio+=0.01
	if path_2d:
		path_follow_2d.progress+=speed
	if path_2d_2:
		path_follow_2d_2.progress+=speed
	if path_2d_3:
		path_follow_2d_3.progress+=speed
	if path_2d_4:
		path_follow_2d_4.progress+=speed
	if path_2d_5:
		path_follow_2d_5.progress+=speed
	if get_node_or_null("Path2D") == null \
	and get_node_or_null("Path2D2") == null \
	and get_node_or_null("Path2D3") == null \
	and get_node_or_null("Path2D4") == null \
	and get_node_or_null("Path2D5") == null:
		queue_free()
	pass


func _on_death_timer_timeout() -> void:
	#queue_free()
	pass # Replace with function body.
