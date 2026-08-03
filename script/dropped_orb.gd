extends Node2D

@onready var timer: Timer = $Timer

@export var speed: float = 200.0
var player: CharacterBody2D
@export var distance_thresh : PlayerStats
var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !is_instance_valid(player):
		return
	if timer.is_stopped():
		var distance = global_position.distance_to(player.global_position)
		if distance <= distance_thresh.orb_distance_threshold:
			var direction = (player.global_position - global_position).normalized()
			global_position += direction * speed * delta
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameEvents.orb.emit()
		queue_free()         # Destroy projectil/e
	pass # Replace with function body.
