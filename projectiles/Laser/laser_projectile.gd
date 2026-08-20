#@tool
extends Node2D

#var collider
var cast_point
var collision_bodies : Array[CharacterBody2D]
var tween:Tween
@onready var line_2d: Line2D = $line_2d
#@onready var hit_particles: GPUParticles2D = $Hit_particles
const HIT_PARTICLES = preload("uid://c4qwmn5h4t8yv")
const EXPLOSION_PARTICLE = preload("uid://rmf1psipscka")

@export var base_stats : WeaponsStat
var damage := 0.0
var is_crit := false
#var current_enemy = null
var damage_timer : float = 0.0
var is_casting :bool = false
var player: CharacterBody2D 
#@export var max_distance:float = 200.0
#@export var max_bounces:int = 5
#@export var ray_offset:float = 1.0
var enemy_damage_timers: Dictionary = {}
var hit_particle_nodes: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	line_2d.add_point(Vector2.ZERO)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not base_stats:
		return
	cast_laser(_delta)
	pass

func cast_laser(_delta):
	var space_state := get_world_2d().direct_space_state
	var start_position := global_position
	var direction := global_transform.x.normalized()
	var remaining_distance := base_stats.laser_max_distance
	var points: Array[Vector2] = []
	points.append(Vector2.ZERO)
	var hit_something := false
	var enemies_hit: Array[Node] = []
	var bounce_count := 0
	
	while remaining_distance>0.0:
		var end_postion:=(start_position+direction*remaining_distance)
		var query:=PhysicsRayQueryParameters2D.create(start_position,end_postion)
		#query.collide_with_areas = true
		query.collide_with_bodies = true
		query.exclude = [player]
		var result := space_state.intersect_ray(query)
		
		if result.is_empty():
			points.append(to_local(end_postion))
			break
		
		var hit_position:Vector2 = result.position
		var collider: Object = result.collider
		var segment_distance := start_position.distance_to(hit_position)
		remaining_distance -= segment_distance
		
		if collider.is_in_group("enemy"):
			hit_something = true
			points.append(to_local(hit_position))
			#points.append(to_local(hit_position))
			#if bounce_count>=base_stats.laser_max_bounce:
				#break
			#bounce_count+=1
			#var normal:Vector2 = result.normal
			#direction = direction.bounce(normal).normalized()
			
			
			if not enemies_hit.has(collider):
				enemies_hit.append(collider)
				damage_enemy(collider,_delta)
			
			start_position = (hit_position+direction*base_stats.laser_ray_offset)
			#start_position = (hit_position+direction)
			continue
		
		if collider.is_in_group("walls"):
			hit_something = true
			points.append(to_local(hit_position))
			if bounce_count>=base_stats.laser_max_bounce:
				break
			bounce_count+=1
			var normal:Vector2 = result.normal
			direction = direction.bounce(normal).normalized()
			
			start_position = (hit_position+direction)
			continue
		
		points.append(to_local(hit_position))
		break
	update_laser_points(points)
	
	if hit_something:
		if not is_casting:
			set_is_casting(true)
	else:
		if is_casting:
			set_is_casting(false)
	pass

func damage_enemy(enemy: Node, delta: float) -> void:
	if not is_instance_valid(enemy):
		return
	if not enemy_damage_timers.has(enemy):
		enemy_damage_timers[enemy] = 0.0
	enemy_damage_timers[enemy] -= delta
	if enemy_damage_timers[enemy] > 0.0:
		return
	enemy_damage_timers[enemy] = base_stats.damage_interval
	var health = enemy.get_node_or_null("health")
	if not health:
		return
	health.remove_health(
		damage,
		is_crit
	)
	if health.current_health <= 0.0:
		var dying_explosion = EXPLOSION_PARTICLE.instantiate()
		dying_explosion.global_position = enemy.global_position
		get_tree().current_scene.add_child(
			dying_explosion
		)
		GameEvents.enemy_killed.emit()
		enemy.queue_free()
		dying_explosion.explode()
		enemy_damage_timers.erase(enemy)
		
func update_laser_points(points: Array[Vector2]) -> void:
	line_2d.clear_points()
	for point in points:
		line_2d.add_point(point)

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
		GameEvents.laser_hit_lost.emit()
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

#func get_bounce_point():
	#return get_collision_point()
#func get_normal_point():
	#return get_collision_normal()
	
func setup(player_stats: PlayerStats, weapon_stats: WeaponsStat):
	base_stats = weapon_stats

	var result = DamageCalculator.get_damage(
		player_stats,
		weapon_stats.laser_damage
	)

	damage = result.damage
	is_crit = result.is_crit
