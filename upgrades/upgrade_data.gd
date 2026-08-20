extends Resource
class_name UpgradeData

enum ValueDisplayType{
	int,
	float
}

@export var id:StringName
@export var display_name:String
@export var icon:Texture2D = null
@export var description:String
@export var of_type_unlock:=false
@export var value:float
@export var value_display_type:ValueDisplayType
@export var orb_cost:int = 1
@export var increment_update:=false
@export var increment_max_value:=2
@export var current_increment:=0
@export var children:Array[UpgradeData]=[]
