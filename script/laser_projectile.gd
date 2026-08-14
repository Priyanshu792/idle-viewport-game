@tool
extends RayCast2D

var collider
var cast_point
var collision_bodies : Array[CharacterBody2D]
var tween:Tween
@onready var line_2d: Line2D = $line_2d
@onready var hit_particles: GPUParticles2D = $Hit_particles
const EXPLOSION_PARTICLE = preload("uid://rmf1psipscka")

@export var base_stats : WeaponsStat
var damage := 0.0
var is_crit := false
var current_enemy = null
var damage_timer : float = 0.0
var is_casting :bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.points[1] = Vector2.ZERO
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_colliding():
		GameEvents.emit_signal("laser_hit")
		if not is_casting:
			set_is_casting(true)
		cast_point = to_local(get_collision_point())
		line_2d.points[1].x = (cast_point.x)
		collider = get_collider()
		hit_particles.position = cast_point
		if is_instance_valid(collider):
			if collider.is_in_group("enemy"):
				if collider != current_enemy:
					current_enemy = collider
					damage_timer = base_stats.damage_interval
				damage_timer -= _delta
				if damage_timer <= 0.0:
					damage_timer = base_stats.damage_interval
					var enemy_health = collider.get_node("health")
					enemy_health.remove_health(damage, is_crit)
					if enemy_health.current_health<=0.0:
						var dying_explosion = EXPLOSION_PARTICLE.instantiate()
						dying_explosion.global_transform = global_transform
						get_tree().current_scene.add_child(dying_explosion)
						GameEvents.enemy_killed.emit()
						collider.queue_free()    # Despawn enemy
						dying_explosion.explode()
		else:
			return
	else:
		if is_casting:
			set_is_casting(false)
		line_2d.points[1] = self.target_position
		#set_is_casting(false)
		current_enemy = null
		damage_timer = 0.0
		
		
	pass

func set_is_casting(cast:bool):
	if is_casting == cast:
		return # Prevent redundant calls
	is_casting = cast
	if is_casting:
		appear()
		hit_particles.emitting = is_casting
		
		pass
	else:
		disappear()
		hit_particles.emitting = is_casting
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

func get_bounce_point():
	return get_collision_point()
func get_normal_point():
	return get_collision_normal()
	
func setup(player_stats: PlayerStats, weapon_stats: WeaponsStat):
	base_stats = weapon_stats

	var result = DamageCalculator.get_damage(
		player_stats,
		weapon_stats.laser_damage
	)

	damage = result.damage
	is_crit = result.is_crit
