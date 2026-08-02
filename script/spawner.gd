extends Node2D

const enemy_scene = preload("uid://dlmmnyoqrqnpg")
@onready var timer: Timer = $Timer
@export var spawn_margin := 100.0
@export var spawn_interval := 2.0

var rng := RandomNumberGenerator.new()

@export var switch_ON_OFF := true

func _ready():
	rng.randomize()
	timer.wait_time = spawn_interval

func _on_timer_timeout() -> void:
	if switch_ON_OFF:
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.global_position = get_spawn_position()
	else:
		return
	pass # Replace with function body.

func get_spawn_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var side = rng.randi_range(0, 3)

	match side:
		0: # Top
			return Vector2(rng.randf_range(0, screen_size.x),-spawn_margin)

		1: # Bottom
			return Vector2(rng.randf_range(0, screen_size.x),screen_size.y + spawn_margin)

		2: # Left
			return Vector2(-spawn_margin,rng.randf_range(0, screen_size.y))

		3: # Right
			return Vector2(screen_size.x + spawn_margin,rng.randf_range(0, screen_size.y))

	return Vector2.ZERO
