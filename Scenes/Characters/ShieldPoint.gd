extends Node2D
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
	
func block() -> void:
	$AnimationPlayer.play("block")
	
func unblock() -> void:
	$AnimationPlayer.play("unblock")
	
func attack() -> void:
	$AnimationPlayer.play("attack")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
