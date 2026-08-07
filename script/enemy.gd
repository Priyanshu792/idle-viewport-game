extends CharacterBody2D

@export var stats: EnemyStat
var move_speed:float
var player: CharacterBody2D

func _ready():
	#print(stats)
	move_speed = stats.enemy_1_speed
	player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta):
	if !is_instance_valid(player):
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * move_speed

	move_and_slide()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#print(player)
		var health_node = body.get_node("health")
		health_node.remove_health(0.01)
	pass # Replace with function body.
