extends Node2D

@onready var rotator: Node2D = $rotator

const ORBITAL_PROJECTILE_ELEMENT = preload("uid://q60os21xfer0")

@export var speed := 10.0
@export var radius := 100

func _process(delta):
	rotator.rotation += speed * delta


func add_orbiting_object(num:int):
	for i in range(num):
		var projectile = ORBITAL_PROJECTILE_ELEMENT.instantiate()
		rotator.add_child(projectile)

	update_positions()


func update_positions():
	var count = rotator.get_child_count()

	for i in range(count):
		var child = rotator.get_child(i)
		var angle = TAU * i / count
		child.position = Vector2(cos(angle), sin(angle)) * radius
