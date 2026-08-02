extends Node2D

@onready var rotator: Node2D = $rotator

@export var speed := 10.0
@export var radius := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var count = rotator.get_child_count()

	for i in range(count):
		var angle = TAU * i / count
		var child = rotator.get_child(i)
		child.position = Vector2(cos(angle), sin(angle)) * radius
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotator.rotation += speed * delta
	pass
