extends RayCast2D

var collider
var cast_point
var collision_bodies : Array[CharacterBody2D]
var tween:Tween
@onready var line_2d: Line2D = $line_2d
@onready var hit_particles: GPUParticles2D = $Hit_particles

var is_casting :bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.points[1] = Vector2.ZERO
	#self.force_raycast_update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(get_collider())
	print(is_casting)
	if is_colliding():
		set_is_casting(true)
		cast_point = to_local(get_collision_point())
		line_2d.points[1] = cast_point
		collider = get_collider()
		hit_particles.position = cast_point
	else:
		line_2d.points[1] = self.target_position
		set_is_casting(false)
	pass

func set_is_casting(cast:bool):
	is_casting = cast
	if is_casting:
		appear()
		hit_particles.emitting = is_casting
	else:
		disappear()
		hit_particles.emitting = is_casting
	pass

func appear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d,"width",15.0,0.2)

	pass
	
func disappear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d,"width",0.0,0.1)

	pass
