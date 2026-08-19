extends Resource
class_name WeaponSettings

func _init() -> void:
	GameEvents.upgrade_buy.connect(_on_upgrade_buy)


func _on_upgrade_buy(upgrade_data: UpgradeData) -> void:
	match upgrade_data.id:
		&"laser_unlock":
			laser = true
	GameEvents.weapon_unlock.emit()

@export var fire_blast := true
@export var spread_fire := false
@export var nuclear_blast := false
@export var laser := false
@export var orbital := false
@export var multi_hit := false

#Energy Orb
#Plasma Ball
#Pulse
#Shockwave
#Beam
#Light Ray
#Prism
#Photon
#Spark
#Glow Bolt
