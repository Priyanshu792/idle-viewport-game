extends Resource
class_name WeaponsStat

@export_group("Fire Blast") 
@export var projectile_speed := 600.0
@export var projectile_damage := 0.5

@export_group("Spread Fire")
@export var spread_fire_speed := 2.0
@export var spread_fire_damage := 0.5

@export_group("Orbital")
@export var orbital_speed := 10.0
@export var orbital_radius := 100
@export var orbital_damage := 0.2
