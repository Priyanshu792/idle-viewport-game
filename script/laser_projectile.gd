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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	cast_point = to_local(get_collision_point())
	if is_colliding():
		if not is_casting:
			set_is_casting(true)
		#cast_point = to_local(get_collision_point())
		line_2d.points[1] = cast_point.round()
		#if get_collision_point().round() == line_2d.points[1]:
		print(str(get_collision_point().round()) + " " + str(line_2d.points[1]))
		collider = get_collider()
		#hit_particles.position = cast_point
	else:
		if is_casting:
			set_is_casting(false)
		#print(self.)
		#line_2d.points[1] = Vector2.ZERO
		line_2d.points[1] = self.target_position
		set_is_casting(false)
	pass

func set_is_casting(cast:bool):
	if is_casting == cast:
		return # Prevent redundant calls
	is_casting = cast
	if is_casting:
		appear()
		#hit_particles.emitting = is_casting
		pass
	else:
		disappear()
		#hit_particles.emitting = is_casting
		pass
	pass

func appear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d,"width",64.0,0.2)

	pass
	
func disappear():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d,"width",10.0,0.1)

	pass
