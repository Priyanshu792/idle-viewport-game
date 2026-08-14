@tool
extends CharacterBody2D

@export var player_stats: PlayerStats


@onready var fire_timer: Timer = $fire_timer
@onready var multi_hit_timer: Timer = $multi_hit_timer

const PROJECTILE = preload("uid://bd61w7ff8rjfq")
const NUCLEAR_BLAST = preload("uid://shut12leynj3")
const SPREAD_PROJECTILE = preload("uid://ccggqqp0kwq08")
const ORBITAL_PROJECTILE = preload("uid://dj45eavxxr0yv")
const PROJECTILE_MULTI_HIT = preload("uid://vq8cujmvgd38")
const LASER_PROJECTILE = preload("uid://bka4mos6b641n")
const LASER_PROJECTILE_SHADER = preload("uid://db4f8mouf6h3p")

@export var weapon_settings : WeaponSettings
@export var weapon_stat : WeaponsStat
var orbitals
var laser
var laser_instance
#var multi_hit_projectiles: Array[Node2D]
@export var player_health_bar:ProgressBar




func _ready() -> void:
	if weapon_settings.orbital:
		orbitals = ORBITAL_PROJECTILE.instantiate()
		get_tree().current_scene.add_child.call_deferred(orbitals)
		await get_tree().process_frame
		orbitals.setup(player_stats, weapon_stat)
		orbitals.add_orbiting_object(5)
	if weapon_settings.laser:
		laser = LASER_PROJECTILE.instantiate()
		add_child.call_deferred(laser)
		await get_tree().process_frame
		laser.setup(player_stats, weapon_stat)
		var laser1_line_2d = laser.find_child("line_2d")
		laser1_line_2d.material = laser1_line_2d.material.duplicate()
		# Access the shader material
		var mat = laser1_line_2d.material as ShaderMaterial
		# Change your parameter (Replace "parameter_name" and the value)
		mat.set_shader_parameter("outline_color",Color.BLUE)
		#test
		laser_instance = LASER_PROJECTILE.instantiate()
		add_child.call_deferred(laser_instance)
		await get_tree().process_frame
		laser_instance.setup(player_stats, weapon_stat)
		var laser2_line_2d = laser_instance.find_child("line_2d")
		laser1_line_2d.material = laser1_line_2d.material.duplicate()
		# Access the shader material
		var mat2 = laser2_line_2d.material as ShaderMaterial
		# Change your parameter (Replace "parameter_name" and the value)
		mat2.set_shader_parameter("outline_color",Color.RED)
	
	GameEvents.laser_hit.connect(laser_bounce)
	GameEvents.laser_hit_lost.connect(laser_hit_lost)
	pass

func _process(_delta: float) -> void:
	if weapon_settings.orbital:
		orbitals.position = global_position
	#if weapon_settings.laser:
		#laser.global_position = global_position
	
	laser_bounce()
	pass

func _physics_process(delta):
	#var input_direction = Input.get_vector("move_left","move_right","move_forward","move_backward")
	#
	#if input_direction != Vector2.ZERO:
		#velocity = velocity.move_toward(input_direction * player_stats.move_speed,player_stats.acceleration * delta)
	#else:
		#velocity = velocity.move_toward(Vector2.ZERO,player_stats.friction * delta)
	var target = get_nearest_enemy()
	if target:
		var target_angle = (target.global_position - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, 5.0 * delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("nuclear"):
		if weapon_settings.nuclear_blast:
			var nuclear_blast = NUCLEAR_BLAST.instantiate()
			get_tree().current_scene.add_child(nuclear_blast)
			nuclear_blast.global_position = global_position
		

		pass

## fetches where the nearest enemy is located
func get_nearest_enemy() -> CharacterBody2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest: CharacterBody2D = null
	var nearest_distance = INF

	for enemy in enemies:
		if enemy is CharacterBody2D:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest = enemy
	return nearest

func fire():
	var target = get_nearest_enemy()
	if target == null:
		return
	var projectile = PROJECTILE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position

	projectile.direction = (target.global_position - global_position).normalized()
	projectile.setup(player_stats, weapon_stat)

func _on_fire_timer_timeout() -> void:
	if weapon_settings.fire_blast:
		fire()
	pass # Replace with function body.
	
#func _on_fire_rate():
	##player_stats.fire_rate = clamp(player_stats.fire_rate - 0.05, 0.1, 1.0)
	#player_stats.fire_rate = max(0.1, player_stats.fire_rate - 0.05)
	#fire_timer.wait_time = player_stats.fire_rate
	#pass


func _on_spread_projectile_timeout() -> void:
	if weapon_settings.spread_fire:
		var spread_projectile = SPREAD_PROJECTILE.instantiate()
		get_tree().current_scene.add_child(spread_projectile)
		spread_projectile.global_position = global_position
		spread_projectile.rotation = global_rotation
		spread_projectile.setup(player_stats, weapon_stat)
	pass # Replace with function body.
	
## Fetches a given number of closest enemies
func get_closest_number_of_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest_enemies:Array = []
	var enemy_distances:= []
	for i in enemies:
		var distances := global_position.distance_squared_to(i.global_position)
		enemy_distances.append({
			"enemy": i,
			"distance": distances
		})
	enemy_distances.sort_custom(func(a,b): return a.distance<b.distance)
	var count = min(player_stats.multi_hit_count,enemy_distances.size())
	for i in range(count):
		closest_enemies.append(enemy_distances[i].enemy)
	return closest_enemies

func fire_multi():
	var target = get_closest_number_of_enemies()
	#print(target)
	if target == null:
		return
	var count = min(player_stats.multi_hit_count,target.size())
	#print(target.size())
	for i in range(count):
		#print(i)
		if i == null:
			return
		var projectile = PROJECTILE_MULTI_HIT.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = global_position
		projectile.direction = (target[i].global_position - global_position).normalized()
		projectile.setup(player_stats, weapon_stat)

func _on_multi_hit_timer_timeout() -> void:
	#if multi_hit_timer.is_stopped():
		#multi_hit_projectiles = 
		#pass
	if weapon_settings.multi_hit:
		fire_multi()
	pass # Replace with function body.

#test
func laser_bounce():
	var laser_bounce_point = laser.get_bounce_point()
	var laser_normal = laser.get_normal_point()
	#print(deg_to_rad(laser_normal))
	# Convert collision point to local space relative to the RayCast2D
	var local_collision: Vector2 = to_local(laser_bounce_point)
	# 3. Calculate the incoming direction vector
	var incoming_dir: Vector2 = laser.target_position.normalized()
	# 4. Calculate the reflected direction vector
	var reflect_dir: Vector2 = incoming_dir.bounce(laser_normal)
	
	laser_instance_damn(laser_bounce_point,reflect_dir)
	pass

func laser_instance_damn(laser_bounce_point,reflect_dir):
	laser_instance.visible = true
	laser_instance.position = to_local(laser_bounce_point)
	laser_instance.rotation = reflect_dir.angle()
	if laser_instance.current_enemy != null:
		print("yo")
		pass
	print(reflect_dir.angle())
	#laser_instance.target_position = Vector2.RIGHT * laser.target_position.length()

func laser_hit_lost():
	if is_instance_valid(laser_instance):
		laser_instance.visible = false
		pass
	pass
