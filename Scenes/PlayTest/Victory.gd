extends Control
func is_class(value: String): return value == "" or .is_class(value)
func get_class() -> String: return ""

#### ACCESSORS ####

#### BUILT-IN ####
func _ready() -> void:
	visible = false
	
func win() -> void:
	visible = true
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
	$AnimationPlayer.play("CLIGNOTE")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
