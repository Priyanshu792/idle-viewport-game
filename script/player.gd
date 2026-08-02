extends CharacterBody2D

const PROJECTILE = preload("uid://bd61w7ff8rjfq")
@onready var fire_timer: Timer = $fire_timer

const MAX_SPEED = 300.0
const ACCELERATION = 1000.0
const FRICTION = 800.0
@export var fire_rate := 1.0

const NUCLEAR_BLAST = preload("uid://shut12leynj3")
const SPREAD_PROJECTILE = preload("uid://ccggqqp0kwq08")

enum Weapon {
	FIRE_BLAST,
	SPREAD_FIRE
}

@export var weapons_switch: Array[bool] = [true,true]

func _ready() -> void:
	GameEvents.fire_rate.connect(_on_fire_rate)
	fire_timer.wait_time = fire_rate
	pass

func _process(delta: float) -> void:
	
	pass

func _physics_process(delta):
	var input_direction = Input.get_vector("move_left","move_right","move_forward","move_backward")

	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * MAX_SPEED,ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)
	var target = get_nearest_enemy()
	if target:
		var target_angle = (target.global_position - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, 5.0 * delta)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("nuclear"):
		var target = get_nearest_enemy()
		if target == null:
			return
		var nuclear_blast = NUCLEAR_BLAST.instantiate()
		
		get_tree().current_scene.add_child(nuclear_blast)
		
		nuclear_blast.global_position = global_position
		

		pass

func get_nearest_enemy() -> CharacterBody2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest: CharacterBody2D = null
	var nearest_distance = INF

	for enemy in enemies:
		if enemy is CharacterBody2D:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest = enemy

	return nearest

func fire():
	var target = get_nearest_enemy()

	if target == null:
		return
	var projectile = PROJECTILE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position

	projectile.direction = (target.global_position - global_position).normalized()


func _on_fire_timer_timeout() -> void:
	if weapons_switch[Weapon.FIRE_BLAST]:
		fire()

	pass # Replace with function body.
	
func _on_fire_rate():
	
	fire_rate = clamp(fire_rate - 0.05, 0.1, 1.0)
	fire_timer.wait_time = fire_rate
	pass


func _on_spread_projectile_timeout() -> void:
	if weapons_switch[Weapon.SPREAD_FIRE]:
		var spread_projectile = SPREAD_PROJECTILE.instantiate()
		get_tree().current_scene.add_child(spread_projectile)
		spread_projectile.global_position = global_position
		spread_projectile.rotation = global_rotation
	pass # Replace with function body.
