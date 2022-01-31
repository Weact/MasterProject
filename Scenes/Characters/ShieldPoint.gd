extends Node2D
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func block() -> void:
	$Weapon/AnimationPlayer.play("block")
	
func unblock() -> void:
	$Weapon/AnimationPlayer.play("unblock")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
