extends CharacterBody2D

@export var stats: EnemyStat
var move_speed := 0.0
var player: CharacterBody2D

func _ready():
	move_speed = stats.enemy_1_speed
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if !is_instance_valid(player):
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * move_speed

	move_and_slide()
