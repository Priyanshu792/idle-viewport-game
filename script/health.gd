extends Node

@export var health := 1.0
@onready var health_bar: TextureProgressBar = $"../health_bar"
#var health_hp
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#health_hp = health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_health(hp:float):
	
	health+=hp
	health_bar.value = health
	pass
	
func remove_health(hp:float):
	health -= hp
	health_bar.value = health
	#print(health)
	pass
