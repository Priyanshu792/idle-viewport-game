extends CharacterBody2D

@export var speed := 150.0

var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if !is_instance_valid(player):
		return

	var direction = (player.global_position - global_position).normalized()
	#print((player.global_position - global_position).normalized())
	#if (player.global_position - global_position).normalized()<=Vector2(0.2,0.2):
		#velocity = Vector2.ZERO
		##print("yes")
	velocity = direction * speed

	move_and_slide()
