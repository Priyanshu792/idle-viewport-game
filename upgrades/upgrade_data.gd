extends Resource
class_name UpgradeData

enum ValueDisplayType{
	int,
	float
}

@export var id:StringName
@export var name:String
@export var icon:Texture2D = null
@export var description:String
@export var value:float
@export var value_diplay_type:ValueDisplayType
@export var orb_cost:int = 1
