extends Control

@onready var hp_lost_label: Label = $hp_lost_Label
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	where commit
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position:y", position.y - 40, timer.wait_time)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_label_text(amount:float):
	hp_lost_label.text = str(amount)
	pass

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
