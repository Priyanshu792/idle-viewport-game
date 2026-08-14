extends Resource
class_name WeaponsStat

enum projectile_types{
	projectile,
	spread_fire,
	orbital
}

@export_group("Fire Blast") 
@export var projectile_speed := 600.0
@export var projectile_damage := 0.5

@export_group("Spread Fire")
@export var spread_fire_speed := 2.0
@export var spread_fire_damage := 0.5

@export_group("Orbital")
@export var orbital_speed := 10.0
@export var orbital_damage := 0.2
@export var orbital_radius := 100

@export_group("Laser")
@export var laser_damage := 0.05
@export var damage_interval := 0.5

@export_group("multi_target")
@export var multi_target_speed := 600.0
@export var multi_target_damage := 0.5
@export var multi_target_count := 3
