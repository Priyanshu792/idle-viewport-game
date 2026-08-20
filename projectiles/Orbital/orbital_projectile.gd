extends Node2D

@onready var rotator: Node2D = $rotator

const ORBITAL_PROJECTILE_ELEMENT = preload("uid://q60os21xfer0")

@export var stats: WeaponsStat
var player_stats : PlayerStats
#var stats : WeaponsStat

func _process(delta):
	rotator.rotation += stats.orbital_speed * delta

func setup(p_stats: PlayerStats, weapon_stats: WeaponsStat):
	player_stats = p_stats
	stats = weapon_stats

func add_orbiting_object(num:int):
	for i in range(num):
		var projectile = ORBITAL_PROJECTILE_ELEMENT.instantiate()
		rotator.add_child(projectile)
		projectile.setup(player_stats, stats)
	update_positions()


func update_positions():
	var count = rotator.get_child_count()

	for i in range(count):
		var child = rotator.get_child(i)
		var angle = TAU * i / count
		child.position = Vector2(cos(angle), sin(angle)) * stats.orbital_radius
