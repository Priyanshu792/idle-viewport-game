extends Node

signal level_up(level)

var level : int = 1
var xp:=0
var xp_to_next:= 5
var orb:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.orb.connect(_on_orb_collected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_xp(amount: int):
	xp += amount

	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1

		# Increase XP requirement each level
		xp_to_next = get_next_requirement(level)

		level_up.emit(level)

func get_next_requirement(_level: int) -> int:
	return int(5 * pow(1.25, level - 1))

func _on_orb_collected():
	add_xp(1)
	orb+=1
