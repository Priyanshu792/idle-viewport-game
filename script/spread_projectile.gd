extends Node2D

var player_stats: PlayerStats
var weapon_stats: WeaponsStat

@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var path_follow_2d_2: PathFollow2D = $Path2D2/PathFollow2D2
@onready var path_follow_2d_3: PathFollow2D = $Path2D3/PathFollow2D3
@onready var path_follow_2d_4: PathFollow2D = $Path2D4/PathFollow2D4
@onready var path_follow_2d_5: PathFollow2D = $Path2D5/PathFollow2D5

@onready var path_2d: Path2D = $Path2D
@onready var path_2d_2: Path2D = $Path2D2
@onready var path_2d_3: Path2D = $Path2D3
@onready var path_2d_4: Path2D = $Path2D4
@onready var path_2d_5: Path2D = $Path2D5


@onready var projectile: Node2D = $Path2D/PathFollow2D/projectile
@onready var projectile_2: Node2D = $Path2D2/PathFollow2D2/projectile2
@onready var projectile_3: Node2D = $Path2D3/PathFollow2D3/projectile3
@onready var projectile_4: Node2D = $Path2D4/PathFollow2D4/projectile4
@onready var projectile_5: Node2D = $Path2D5/PathFollow2D5/projectile5

@export var speed : WeaponsStat
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if path_2d:
		path_follow_2d.progress+=speed.spread_fire_speed
	if path_2d_2:
		path_follow_2d_2.progress+=speed.spread_fire_speed
	if path_2d_3:
		path_follow_2d_3.progress+=speed.spread_fire_speed
	if path_2d_4:
		path_follow_2d_4.progress+=speed.spread_fire_speed
	if path_2d_5:
		path_follow_2d_5.progress+=speed.spread_fire_speed
	if get_node_or_null("Path2D") == null \
	and get_node_or_null("Path2D2") == null \
	and get_node_or_null("Path2D3") == null \
	and get_node_or_null("Path2D4") == null \
	and get_node_or_null("Path2D5") == null:
		queue_free()
	pass
	
func setup(p_stats: PlayerStats, w_stats: WeaponsStat):
	player_stats = p_stats
	weapon_stats = w_stats
	
	projectile.setup(player_stats, weapon_stats)
	projectile_2.setup(player_stats, weapon_stats)
	projectile_3.setup(player_stats, weapon_stats)
	projectile_4.setup(player_stats, weapon_stats)
	projectile_5.setup(player_stats, weapon_stats)
